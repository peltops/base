import { SupabaseClient } from "jsr:@supabase/supabase-js@2";
import { eImunisasiSupabaseAdmin } from "../_shared/eimunisasiSupabase.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey",
  "Access-Control-Allow-Methods": "GET",
};

interface GetPatientsQuery {
  page?: number;
  page_size?: number;
  nik?: string;
}

async function getAllPatients(
  supabaseClient: SupabaseClient,
  query?: GetPatientsQuery
) {
  const { 
    page = 1,
    page_size = 10,
    nik 
  } = query ?? {};
  const start = (page - 1) * page_size;
  const end = start + page_size - 1;

  const { count, error: countError } = await supabaseClient
    .from("children")
    .select("*", { count: "exact", head: true })
    .ilike("nik", `%${nik}%`)

  if (countError) {
    throw countError;
  }

  const { data, error } = await supabaseClient
    .from("children")
    .select(
      `
        id,
        nik,
        name,
        blood_type,
        gender,
        avatar_url,
        date_of_birth,
        place_of_birth,
      `
    )
    .ilike("nik", `%${nik}%`)
    .range(start, end);

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

async function getPatient(supabaseClient: SupabaseClient, id: string) {
  const { data, error } = await supabaseClient
    .from("children")
    .select(
      `
        id,
        nik,
        name,
        blood_type,
        gender,
        avatar_url,
        date_of_birth,
        place_of_birth,
      `
    )
    .eq("id", id)
    .limit(1)
    .single();

  if (error) {
    if (error.code === "PGRST116") {
      const response = JSON.stringify({
        is_successful: false,
        message: "Child not found",
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

Deno.serve(async (req) => {
  const { url, method } = req;

  if (method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const supabaseClient = eImunisasiSupabaseAdmin;

    const taskPattern = new URLPattern({ pathname: "/patients/:id" });
    const matchingPath = taskPattern.exec(url);
    const id = matchingPath ? matchingPath.pathname.groups.id : null;

    switch (true) {
      case id && method === "GET":
        return await getPatient(supabaseClient, id);
      case method === "GET":
        const query = new URL(url).searchParams;
        const page = query.get("page");
        const page_size = query.get("page_size");
        const nik = query.get("nik") || undefined;
        const patientQuery: GetPatientsQuery = {
          page: page ? Number(page) : 1,
          page_size: page_size ? Number(page_size) : 10,
          nik,
        };
        return await getAllPatients(supabaseClient, patientQuery);
      default:
        const response = JSON.stringify({
          is_successful: false,
          message: "Method not allowed",
        });
        return new Response(response, {
          headers: { ...corsHeaders, "Content-Type": "application/json" },
          status: 405,
        });
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
