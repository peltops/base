import { SupabaseClient } from "jsr:@supabase/supabase-js@2";
import { eImunisasiSupabaseAdmin } from "../_shared/eimunisasiSupabase.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey",
  "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE",
};

const tableName = "checkups";

interface GetCheckupsQuery {
  page?: number;
  page_size?: number;
  date?: string;
  patient_id?: string;
}

async function getCheckups(supabaseClient: SupabaseClient, query?: GetCheckupsQuery) {
  const { 
    page = 1,
    page_size = 10,
    date,
    patient_id: patientId,
  } = query ?? {};
  const start = (page - 1) * page_size;
  const end = start + page_size - 1;

  if (!patientId) {
    const response = JSON.stringify({
      is_successful: false,
      message: "patient_id is required",
    });
    return new Response(response, {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 400,
    });
  }

  let countBuilder = supabaseClient
    .from(tableName)
    .select("*", { count: "exact", head: true })
    .eq("child_id", patientId);

  if (date) {
    countBuilder = countBuilder.eq("created_at", date);
  }

  const { count, error: countError } = await countBuilder;

  if (countError) {
    throw countError;
  }
  
  let queryBuilder = supabaseClient
    .from(tableName)
    .select(
      `
        *
      `
    )
    .eq("child_id", patientId)
    .order("created_at")
    .range(start, end);

  if (date) {
    queryBuilder = queryBuilder.eq("created_at", date);
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

async function getCheckup(supabaseClient: SupabaseClient, id: string) {
  const { data, error } = await supabaseClient
    .from(tableName)
    .select(
      `
        *
      `
    )
    .eq("id", id)
    .limit(1)
    .single();

  if (error) {
    if (error.code === "PGRST116") {
      const response = JSON.stringify({
        is_successful: false,
        message: "checkup not found",
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

async function updateCheckup(
  supabaseClient: SupabaseClient,
  body: any,
) {
  const { data, error } = await supabaseClient
    .from(tableName)
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

async function createCheckup(supabaseClient: SupabaseClient, body: any) {
  const { data, error } = await supabaseClient
    .from(tableName)
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

  try {
    const supabaseClient = eImunisasiSupabaseAdmin;
    
    const taskPattern = new URLPattern({ pathname: "/checkups/:id" });
    const matchingPath = taskPattern.exec(url);
    const id = matchingPath ? matchingPath.pathname.groups.id : null;

    let checkup = null;
    if (method === "POST" || method === "PUT") {
      const body = await req.json();
      checkup = body;
      if (method === "PUT") {
        checkup.id = id;
      }
    }

    switch (true) {
      case id && method === "GET":
        return getCheckup(supabaseClient, id as string);
      case id && method === "PUT":
        return updateCheckup(supabaseClient, checkup);
      case method === "POST":
        return createCheckup(supabaseClient, checkup);
      case method === "GET":
        return getCheckups(
          supabaseClient,
          Object.fromEntries(new URL(url).searchParams)
        );
      default:
        return getCheckups(
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
