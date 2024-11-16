import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { enakesSupabaseAdmin } from "../_shared/enakesSupabase.ts";

Deno.serve(async (req) => {
  try {
    const url = new URL(req.url);
    const id = url.pathname.split("/").pop();
    if (!id) {
      throw new Error("id is required");
    }

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

    const response = JSON.stringify({
      data,
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
