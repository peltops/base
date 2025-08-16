import * as jose from "https://deno.land/x/jose@v4.14.4/index.ts";

const JWT_SECRET = Deno.env.get("JWT_SECRET");

export function getAuthToken(req: Request): string {
  const authHeader = req.headers.get("authorization");
  if (!authHeader) {
    throw new Error("Missing authorization header");
  }
  const [bearer, token] = authHeader.split(" ");
  if (bearer !== "Bearer") {
    throw new Error(`Auth header is not 'Bearer {token}'`);
  }
  return token;
}

export async function verifyJWT(jwt: string): Promise<boolean> {
  if (!JWT_SECRET) {
    throw new Error("JWT_SECRET is not configured");
  }

  const encoder = new TextEncoder();
  const secretKey = encoder.encode(JWT_SECRET);
  try {
    await jose.jwtVerify(jwt, secretKey);
    return true;
  } catch (err) {
    console.error("JWT verification failed:", err);
    return false;
  }
}

export async function validateJWT(
  req: Request
): Promise<{ isValid: boolean; error?: string }> {
  try {
    const token = getAuthToken(req);
    const isValid = await verifyJWT(token);

    if (!isValid) {
      return { isValid: false, error: "Invalid JWT token" };
    }

    return { isValid: true };
  } catch (error) {
    return { isValid: false, error: error.message };
  }
}
