-- migrate:up

-- Function: handle_new_user
-- Purpose: Automatically create a profile for a new user if one does not already exist.
CREATE OR REPLACE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.profiles WHERE user_id = new.id) THEN
    INSERT INTO public.profiles (user_id, avatar_url, full_name)
    VALUES (new.id, new.raw_user_meta_data->>'avatar_url', new.raw_user_meta_data->>'full_name');
  END IF;
  RETURN new;
END;$$;

create table
public.profiles (
id uuid not null default gen_random_uuid (),
user_id uuid not null default auth.uid (),
avatar_url text null,
full_name text null,
updated_at timestamp with time zone null,
constraint profiles_pkey primary key (id),
constraint profiles_user_id_key unique (user_id),
constraint profiles_user_id_fkey foreign key (user_id) references auth.users (id) on update cascade on delete cascade
) tablespace pg_default;

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- policy: Enable crud_only_by_owner
-- Rationale: Allow users to crud only their own profile.
CREATE policy "crud only by owner"
on "public"."profiles" for all
to authenticated
using (
  (auth.uid() = user_id)
);

CREATE policy "service_role full access"
on "public"."profiles" for all
to service_role
using (true);

-- migrate:down
DROP POLICY IF EXISTS "crud_only_by_owner" ON public.profiles;

ALTER TABLE public.profiles DISABLE ROW LEVEL SECURITY;

DROP TABLE IF EXISTS public.profiles CASCADE;

DROP FUNCTION IF EXISTS public.handle_new_user() CASCADE;