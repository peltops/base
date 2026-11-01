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

  const url = new URL(req.url);
  const page = url.searchParams.get("page") ?? 1;
  const pageSize = url.searchParams.get("pageSize") ?? 10;
  const search = url.searchParams.get("search") ?? "";

  try {
    const client = enakesSupabaseAdmin;
    const start = (page - 1) * pageSize;
    const end = start + pageSize - 1;

    const { count, error: countError } = await client
      .from("profiles")
      .select("*", { count: "exact", head: true })
      .ilike("full_name", `%${search}%`);

    if (countError) {
      throw countError;
    }

    const bookingProduct = await getBookingProduct();

    const { data, error } = await client
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
      .ilike("full_name", `%${search}%`)
      .range(start, end);

    if (error) {
      throw error;
    }
    const result = data.map((item) => {
      return {
        ...item,
        booking_fee: bookingProduct.price,
      };
    });
    const response = JSON.stringify({
      data: result,
      metadata: {
        page: Number(page),
        pageSize: Number(pageSize),
        total: count,
      },
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
