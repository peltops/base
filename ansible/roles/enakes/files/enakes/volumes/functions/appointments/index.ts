import { SupabaseClient } from "jsr:@supabase/supabase-js@2";
import { eImunisasiSupabaseAdmin } from "../_shared/eimunisasiSupabase.ts";
import { validateJWT } from "../_shared/jwtAuth.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey",
  "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE",
};

interface GetAppointmentsQuery {
  page?: number;
  page_size?: number;
  date?: string;
  user_id?: string;
}

async function getAllAppointments(
  supabaseClient: SupabaseClient,
  query?: GetAppointmentsQuery
) {
  const { page = 1, page_size = 10, date, user_id: userId } = query ?? {};
  const start = (page - 1) * page_size;
  const end = start + page_size - 1;

  if (!userId) {
    const response = JSON.stringify({
      is_successful: false,
      message: "user_id is required",
    });
    return new Response(response, {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 400,
    });
  }

  let countBuilder = supabaseClient
    .from("appointments")
    .select("*", { count: "exact", head: true })
    .eq("inspector_id", userId);

  if (date) {
    countBuilder = countBuilder.eq("date", date);
  }

  const { count, error: countError } = await countBuilder;

  if (countError) {
    throw countError;
  }

  let queryBuilder = supabaseClient
    .from("appointments")
    .select(
      `
      id,
      parent:parent_id (name:mother_name),
      child:child_id (name),
      note,
      date,
      purpose,
      start_time,
      end_time
      `
    )
    .eq("inspector_id", userId)
    .order("date")
    .range(start, end);

  if (date) {
    queryBuilder = queryBuilder.eq("date", date);
  }

  const { data, error } = await queryBuilder;

  if (error) {
    throw error;
  }

  const response = JSON.stringify({
    data,
    metadata: {
      page: Number(page),
      page_size: Number(page_size),
      total: count,
    },
    is_successful: true,
  });
  return new Response(response, {
    headers: { "Content-Type": "application/json" },
    status: 200,
  });
}

async function getAppointment(supabaseClient: SupabaseClient, id: string) {
  const { data, error } = await supabaseClient
    .from("appointments")
    .select(
      `
        id,
        parent:parent_id (
          id:user_id,
          name:mother_name,
          avatar_url
        ),
        child:child_id (
          id,
          parent_id,
          name,
          avatar_url,
          nik,
          date_of_birth,
          place_of_birth,
          blood_type,
          gender
        ),
        note,
        date,
        purpose,
        start_time,
        end_time
        `
    )
    .eq("id", id)
    .limit(1)
    .single();

  if (error) {
    if (error.code === "PGRST116") {
      const response = JSON.stringify({
        is_successful: false,
        message: "appointment not found",
      });
      return new Response(response, {
        status: 404,
      });
    }
    throw error;
  }

  const response = JSON.stringify({
    data,
    is_successful: true,
  });
  return new Response(response, {
    headers: { ...corsHeaders, "Content-Type": "application/json" },
    status: 200,
  });
}

async function deleteAppointment(supabaseClient: SupabaseClient, id: string) {
  const response = await supabaseClient
    .from("appointments")
    .delete()
    .eq("id", id);

  if (response.status !== 204) {
    throw new Error("Failed to delete appointment");
  }

  return new Response(null, {
    headers: { ...corsHeaders, "Content-Type": "application/json" },
    status: 204,
  });
}

async function updateAppointment(
  supabaseClient: SupabaseClient,
  id: string,
  body
) {
  const { data, error } = await supabaseClient
    .from("appointments")
    .update(body)
    .eq("id", body.id)
    .select();
  if (error) throw error;

  const response = JSON.stringify({
    data,
    is_successful: true,
  });

  return new Response(response, {
    headers: { ...corsHeaders, "Content-Type": "application/json" },
    status: 200,
  });
}

async function createAppointment(supabaseClient: SupabaseClient, body) {
  const { data, error } = await supabaseClient
    .from("appointments")
    .insert(body)
    .select();

  if (error) {
    throw error;
  }

  const response = JSON.stringify({
    data,
    is_successful: true,
  });
  return new Response(response, {
    headers: { ...corsHeaders, "Content-Type": "application/json" },
    status: 200,
  });
}

Deno.serve(async (req) => {
  const { url, method } = req;

  if (method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  // JWT Authentication
  const jwtValidation = await validateJWT(req);
  if (!jwtValidation.isValid) {
    const response = JSON.stringify({
      is_successful: false,
      message: jwtValidation.error || "Authentication failed",
    });
    return new Response(response, {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 401,
    });
  }

  try {
    const supabaseClient = eImunisasiSupabaseAdmin;

    const taskPattern = new URLPattern({ pathname: "/appointments/:id" });
    const matchingPath = taskPattern.exec(url);
    const id = matchingPath ? matchingPath.pathname.groups.id : null;

    let appointment = null;
    if (method === "POST" || method === "PUT") {
      const body = await req.json();
      appointment = body;
    }

    switch (true) {
      case id && method === "GET":
        return getAppointment(supabaseClient, id as string);
      case id && method === "PUT":
        return updateAppointment(supabaseClient, id as string, appointment);
      case id && method === "DELETE":
        return deleteAppointment(supabaseClient, id as string);
      case method === "POST":
        return createAppointment(supabaseClient, appointment);
      case method === "GET":
        return getAllAppointments(
          supabaseClient,
          Object.fromEntries(new URL(url).searchParams)
        );
      default:
        return getAllAppointments(
          supabaseClient,
          Object.fromEntries(new URL(url).searchParams)
        );
    }
  } catch (error) {
    console.error(error);

    const response = JSON.stringify({
      is_successful: false,
      message: "Something went wrong, please try again later",
    });
    return new Response(response, {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 400,
    });
  }
});
