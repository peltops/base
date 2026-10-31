import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { enakesSupabaseAdmin } from "../_shared/enakesSupabase.ts";
import {
  getBookingProduct,
  paymentSupabaseAdmin,
} from "../_shared/paymentSupabase.ts";
import { validateJWT } from "../_shared/jwtAuth.ts";

Deno.serve(async (req) => {
  // JWT Authentication
  if (req.method !== "OPTIONS") {
    const validation = await validateJWT(req);

    if (!validation.isValid) {
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
    const url = new URL(req.url);
    const id = url.pathname.split("/").pop();
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
    return new Response(response, {
      headers: { "Content-Type": "application/json" },
      status: 200,
    });
  } catch (err) {
    const response = JSON.stringify({
      isSuccessful: false,
      message: err?.message ?? err,
    });
    return new Response(response, {
      status: 500,
    });
  }
});
