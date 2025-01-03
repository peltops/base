import { SupabaseClient } from "jsr:@supabase/supabase-js@2";
import { eImunisasiSupabaseAdmin } from "../_shared/eimunisasiSupabase.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey",
  "Access-Control-Allow-Methods": "GET",
};

async function getParent(supabaseClient: SupabaseClient, id: string) {
  const { data, error } = await supabaseClient
    .from("profiles")
    .select(
      `
        id:user_id,
        name:mother_name,
        phone_number:mother_phone_number
      `
    )
    .eq("user_id", id)
    .limit(1)
    .single();

  if (error) {
    if (error.code === "PGRST116") {
      const response = JSON.stringify({
        is_successful: false,
        message: "Parent not found",
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

    const taskPattern = new URLPattern({ pathname: "/parents/:id" });
    const matchingPath = taskPattern.exec(url);
    const id = matchingPath ? matchingPath.pathname.groups.id : null;

    switch (true) {
      case id && method === "GET":
        return await getParent(supabaseClient, id);
      case method === "GET":
        const idRequiredResponse = JSON.stringify({
          is_successful: false,
          message: "id is required",
        });
        return new Response(idRequiredResponse, {
          headers: { ...corsHeaders, "Content-Type": "application/json" },
          status: 400,
        });
      default:
        const methodNotAllowedResponse = JSON.stringify({
          is_successful: false,
          message: "Method not allowed",
        });
        return new Response(methodNotAllowedResponse, {
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
