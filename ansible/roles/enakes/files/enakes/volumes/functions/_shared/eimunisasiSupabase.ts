import { createClient } from 'jsr:@supabase/supabase-js@2'

const EIMUNISASI_SUPABASE_URL = Deno.env.get('EIMUNISASI_SUPABASE_URL')
const EIMUNISASI_SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('EIMUNISASI_SUPABASE_SERVICE_ROLE_KEY')
const EIMUNISASI_SUPABASE_ANON_KEY = Deno.env.get('EIMUNISASI_SUPABASE_ANON_KEY')

 const eImunisasiSupabaseAdmin = createClient(
  EIMUNISASI_SUPABASE_URL ?? '',
  EIMUNISASI_SUPABASE_SERVICE_ROLE_KEY ?? '',
)

 const eImunisasiSupabaseClient = createClient(
  EIMUNISASI_SUPABASE_URL ?? '',
  EIMUNISASI_SUPABASE_ANON_KEY ?? '',
)

export { eImunisasiSupabaseAdmin, eImunisasiSupabaseClient }