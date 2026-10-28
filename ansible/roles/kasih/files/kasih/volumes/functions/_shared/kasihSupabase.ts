import { createClient } from 'jsr:@supabase/supabase-js@2'

const KASIH_SUPABASE_URL = Deno.env.get('SUPABASE_URL')
const KASIH_SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')
const KASIH_SUPABASE_ANON_KEY = Deno.env.get('SUPABASE_ANON_KEY')

const kasihSupabaseAdmin = createClient(
  KASIH_SUPABASE_URL ?? '',
  KASIH_SUPABASE_SERVICE_ROLE_KEY ?? '',
)

const kasihSupabaseClient = (req: any) => createClient(
  KASIH_SUPABASE_URL ?? '',
  KASIH_SUPABASE_ANON_KEY ?? '',
  { global: { headers: { Authorization: req.headers.get('Authorization')! } } }
)

export { kasihSupabaseAdmin, kasihSupabaseClient }
