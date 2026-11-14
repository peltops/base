// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { validateJWT } from "../_shared/jwtAuth.ts";

serve(async (req) => {
  const url = new URL(req.url);
  console.log(`[hello] [${req.method}] ${url.pathname}`);

  // JWT Authentication
  if (req.method !== "OPTIONS") {
    const validation = await validateJWT(req);

    if (!validation.isValid) {
      console.warn(`[hello] [${req.method}] Invalid JWT: ${validation.error}`);
      return new Response(
        JSON.stringify({
          isSuccessful: false,
          message: validation.error || "Invalid JWT",
        }),
        {
          status: 401,
          headers: { "Content-Type": "application/json" },
        }
      );
    }
  }

  console.log(`[hello] Responding with greeting message`);
  return new Response(`"Hello from Edge Functions!"`, {
    headers: { "Content-Type": "application/json" },
  });
});

// To invoke:
// curl 'http://localhost:<KONG_HTTP_PORT>/functions/v1/hello' \
//   --header 'Authorization: Bearer <anon/service_role API key>'
