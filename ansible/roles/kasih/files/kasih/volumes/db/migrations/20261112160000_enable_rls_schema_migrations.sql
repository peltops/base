-- migrate:up
ALTER TABLE IF EXISTS public.schema_migrations ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.schema_migrations FROM anon, authenticated;
NOTIFY pgrst, 'reload schema';

-- migrate:down
ALTER TABLE IF EXISTS public.schema_migrations DISABLE ROW LEVEL SECURITY;
NOTIFY pgrst, 'reload schema';
