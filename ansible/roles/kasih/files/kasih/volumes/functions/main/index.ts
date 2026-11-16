import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { validateJWT } from "../_shared/jwtAuth.ts";

console.log("main function started");

const VERIFY_JWT = Deno.env.get("VERIFY_JWT") === "true";

serve(async (req: Request) => {
  const url = new URL(req.url);
  const { pathname } = url;
  console.log(`[main] [${req.method}] ${pathname}`);

  if (req.method !== "OPTIONS" && VERIFY_JWT) {
    const validation = await validateJWT(req);

    if (!validation.isValid) {
      console.warn(`[main] [${req.method}] ${pathname} - Invalid JWT: ${validation.error}`);
      return new Response(
        JSON.stringify({ msg: validation.error || "Invalid JWT" }),
        {
          status: 401,
          headers: { "Content-Type": "application/json" },
        }
      );
    }
  }

  const path_parts = pathname.split("/");
  const service_name = path_parts[1];

  if (!service_name || service_name === "") {
    console.warn(`[main] [${req.method}] ${pathname} - Missing function name in request`);
    const error = { msg: "missing function name in request" };
    return new Response(JSON.stringify(error), {
      status: 400,
      headers: { "Content-Type": "application/json" },
    });
  }

  const servicePath = `/home/deno/functions/${service_name}`;
  console.log(`[main] Dispatching [${req.method}] ${pathname} to worker at ${servicePath}`);

  const memoryLimitMb = 150;
  const workerTimeoutMs = 1 * 60 * 1000;
  const noModuleCache = false;
  const importMapPath = null;
  const envVarsObj = Deno.env.toObject();
  const envVars = Object.keys(envVarsObj).map((k) => [k, envVarsObj[k]]);

  try {
    const worker = await EdgeRuntime.userWorkers.create({
      servicePath,
      memoryLimitMb,
      workerTimeoutMs,
      noModuleCache,
      importMapPath,
      envVars,
    });
    const res = await worker.fetch(req);
    console.log(`[main] [${req.method}] ${pathname} completed with status ${res.status}`);
    return res;
  } catch (e: any) {
    console.error(`[main] Error invoking user worker for ${service_name} (${pathname}):`, e);
    const error = { msg: e?.message ?? String(e) };
    return new Response(JSON.stringify(error), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});
