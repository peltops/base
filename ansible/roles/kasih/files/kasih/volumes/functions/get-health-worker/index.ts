import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { enakesSupabaseAdmin } from "../_shared/enakesSupabase.ts";
import {
  getBookingProduct,
  paymentSupabaseAdmin,
} from "../_shared/paymentSupabase.ts";
import { validateJWT } from "../_shared/jwtAuth.ts";

Deno.serve(async (req) => {
  const url = new URL(req.url);
  const id = url.pathname.split("/").pop();
  console.log(`[get-health-worker] [${req.method}] ${url.pathname} (id: ${id})`);

  // JWT Authentication
  if (req.method !== "OPTIONS") {
    const validation = await validateJWT(req);

    if (!validation.isValid) {
      console.warn(`[get-health-worker] [${req.method}] Invalid JWT: ${validation.error}`);
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

  try {
    if (!id) {
      throw new Error("id is required");
    }

    const bookingProduct = await getBookingProduct();

    const { data, error } = await enakesSupabaseAdmin
      .from("profiles")
      .select(
        `
        id:user_id,
        full_name,
        clinic:clinic_id (name),
        practice_schedules (
          id,
          day:day_id (*),
          start_time, 
          end_time
        ),
        avatar_url,
        profession
        `
      )
      .eq("user_id", id)
      .limit(1)
      .single();

    if (error) {
      if (error.code === "PGRST116") {
        console.warn(`[get-health-worker] Health worker not found for id: ${id}`);
        const response = JSON.stringify({
          isSuccessful: false,
          message: "health worker not found",
        });
        return new Response(response, {
          status: 404,
        });
      }
      throw error;
    }
    const result = {
      ...data,
      booking_fee: bookingProduct.price,
    };

    const response = JSON.stringify({
      data: result,
      isSuccessful: true,
    });
    console.log(`[get-health-worker] Successfully retrieved health worker for id: ${id}`);
    return new Response(response, {
      headers: { "Content-Type": "application/json" },
      status: 200,
    });
  } catch (err) {
    console.error(`[get-health-worker] Error fetching health worker (id: ${id}):`, err);
    const response = JSON.stringify({
      isSuccessful: false,
      message: err?.message ?? err,
    });
    return new Response(response, {
      status: 500,
    });
  }
});
