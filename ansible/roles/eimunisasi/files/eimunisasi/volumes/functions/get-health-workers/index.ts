import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { enakesSupabaseAdmin } from "../_shared/enakesSupabase.ts";

Deno.serve(async (req) => {
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

    const response = JSON.stringify({
      data,
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
