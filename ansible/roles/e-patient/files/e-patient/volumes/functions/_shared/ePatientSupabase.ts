import { createClient } from 'jsr:@supabase/supabase-js@2'

const E_PATIENT_SUPABASE_URL = Deno.env.get('SUPABASE_URL')
const E_PATIENT_SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')
const E_PATIENT_SUPABASE_ANON_KEY = Deno.env.get('SUPABASE_ANON_KEY')

const ePatientSupabaseAdmin = createClient(
  E_PATIENT_SUPABASE_URL ?? '',
  E_PATIENT_SUPABASE_SERVICE_ROLE_KEY ?? '',
)

const ePatientSupabaseClient = (req: any) => createClient(
  E_PATIENT_SUPABASE_URL ?? '',
  E_PATIENT_SUPABASE_ANON_KEY ?? '',
  { global: { headers: { Authorization: req.headers.get('Authorization')! } } }
)

export { ePatientSupabaseAdmin, ePatientSupabaseClient }
