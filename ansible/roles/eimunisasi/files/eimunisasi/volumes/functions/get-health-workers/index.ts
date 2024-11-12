import "jsr:@supabase/functions-js/edge-runtime.d.ts"
import { enakesSupabaseAdmin } from '../_shared/enakesSupabase.ts'

Deno.serve(async (req) => {

  try {
    const client = enakesSupabaseAdmin(req)
    const { data, error } = await client
      .from('profiles')
      .select(
        `
        id,
        full_name,
        clinics:clinic_id (name),
        avatar_url,
        profession
        `
      )

    if (error) {
      throw error
    }

    const response = JSON.stringify({ 
      data,
      isSuccessful: true,
    })
    return new Response(
      response,
      {
        headers: { 'Content-Type': 'application/json' },
        status: 200,
      },
    )
  } catch (err) {
    const response = JSON.stringify({
      isSuccessful: false,
      message: err?.message ?? err,
    })
    return new Response(
      response,
      { 
      status: 500,
      }
    )
  }
})
