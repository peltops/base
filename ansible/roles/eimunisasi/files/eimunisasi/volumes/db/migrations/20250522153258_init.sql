-- migrate:up
--
-- Name: blood_type; Type: TYPE; Schema: public;
--

CREATE TYPE public.blood_type AS ENUM (
    'A',
    'B',
    'AB',
    'O'
);


--
-- Name: gender_type; Type: TYPE; Schema: public;
--

CREATE TYPE public.gender_type AS ENUM (
    'MALE',
    'FEMALE'
);


--
-- Name: handle_new_user(); Type: FUNCTION; Schema: public;
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql
    AS $$begin
  insert into public.profiles (user_id, avatar_url)
  values (new.id, new.raw_user_meta_data->>'avatar_url');
  return new;
end;$$;


--
-- Name: handle_new_user_2(); Type: FUNCTION; Schema: public;
--

CREATE OR REPLACE FUNCTION public.handle_new_user_2() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.profiles WHERE user_id = new.id) THEN
    INSERT INTO public.profiles (user_id, avatar_url, father_name)
    VALUES (new.id, new.raw_user_meta_data->>'avatar_url', new.raw_user_meta_data->>'full_name');
  END IF;
  RETURN new;
END;$$;

create table
public.profiles (
id uuid not null default gen_random_uuid (),
updated_at timestamp with time zone null,
avatar_url text null,
place_of_birth character varying null,
date_of_birth date null,
no_induk_kependudukan character varying null,
no_kartu_keluarga character varying null,
address text null,
father_name character varying null,
mother_name character varying null,
father_blood_type public.blood_type null,
mother_blood_type public.blood_type null,
father_phone_number character varying null,
mother_phone_number character varying null,
father_job character varying null,
mother_job character varying null,
user_id uuid null default uid (),
constraint profiles_pkey primary key (id),
constraint profiles_user_id_key unique (user_id),
constraint profiles_user_id_fkey foreign key (user_id) references auth.users (id) on update cascade on delete set null
) tablespace pg_default;

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE policy "Enable insert for authenticated users only"
on "public"."profiles"
to authenticated, service_role
with check (
  true
);

CREATE policy "Enable update for authenticated users only"
on "public"."profiles"
to authenticated, service_role
using (
  (( SELECT uid() AS uid) = user_id)
);

CREATE policy "Enable select for authenticated and service role users only"
on "public"."profiles"
to authenticated, service_role
using (
    true
);

create table
  public.children (
    id uuid not null default gen_random_uuid (),
    created_at timestamp with time zone not null default now(),
    parent_id uuid null default uid (),
    nik character varying null,
    name character varying not null,
    blood_type public.blood_type null,
    gender public.gender_type null,
    avatar_url text null,
    date_of_birth date not null,
    place_of_birth character varying null,
    constraint children_pkey primary key (id),
    constraint children_nik_key unique (nik),
    constraint children_parent_id_fkey foreign key (parent_id) references auth.users (id) on update cascade on delete set null
  ) tablespace pg_default;

ALTER TABLE public.children ENABLE ROW LEVEL SECURITY;

CREATE policy "Enable delete for children based on parent_id"
on "public"."children"
to authenticated, service_role
using (
  (( SELECT uid() AS uid) = parent_id) 
);

CREATE policy "Enable insert for children based on parent_id"
on "public"."children"
to authenticated, service_role
with check (
  (( SELECT uid() AS uid) = parent_id)
);

CREATE policy "Enable update for children based on parent_id"
on "public"."children"
to authenticated, service_role
using (
  (( SELECT uid() AS uid) = parent_id)
);

CREATE policy "Enable select for children based on parent_id"
on "public"."children"
to authenticated, service_role
using (
  (( SELECT uid() AS uid) = parent_id)
);

-- 3. Now create appointments table (depends on auth.users, children, and profiles)
create table if not exists
  public.appointments (
    id uuid not null default gen_random_uuid (),
    parent_id uuid null,
    child_id uuid null,
    inspector_id uuid null,
    note character varying null,
    date timestamp with time zone not null,
    purpose character varying not null,
    created_at timestamp with time zone not null default now(),
    updated_at timestamp with time zone null,
    start_time time without time zone not null,
    end_time time without time zone not null,
    order_id uuid null,
    constraint appointments_pkey primary key (id),
    constraint appointments_parent_id_fkey foreign key (parent_id) references auth.users (id) on update cascade on delete set null,
    constraint appointments_child_id_fkey foreign key (child_id) references children (id) on update cascade on delete set null,
    constraint appointments_parent_id_fkey1 foreign key (parent_id) references profiles (user_id)
  ) tablespace pg_default;

ALTER TABLE public.appointments ENABLE ROW LEVEL SECURITY;

CREATE POLICY all_rls_appointments
ON public.appointments
to authenticated, service_role
USING (true);

create table
public.blog_tags (
id uuid not null default gen_random_uuid (),
name character varying not null,
created_at timestamp with time zone not null default now(),
constraint blog_tags_pkey primary key (id),
constraint blog_tags_name_key unique (name)
) tablespace pg_default;

ALTER TABLE public.blog_tags ENABLE ROW LEVEL SECURITY;

CREATE POLICY all_rls_blog_tags
ON public.blog_tags
to authenticated, service_role
USING (true);

create table
public.blogs (
id uuid not null default gen_random_uuid (),
title character varying not null,
body text not null,
tag_id uuid not null,
author character varying null,
created_at timestamp with time zone not null default now(),
updated_at timestamp with time zone null,
constraint blogs_pkey primary key (id),
constraint blogs_tag_id_fkey foreign key (tag_id) references blog_tags (id) on update cascade on delete set null
) tablespace pg_default;

ALTER TABLE public.blogs ENABLE ROW LEVEL SECURITY;

CREATE POLICY all_rls_blogs
ON public.blogs
to authenticated, service_role
USING (true);

create table
public.calendars (
  id uuid not null default gen_random_uuid (),
  created_at timestamp with time zone not null default now(),
  parent_id uuid null default uid (),
  activity character varying not null,
  do_at timestamp with time zone not null,
  read_only boolean not null default false,
  constraint calendars_pkey primary key (id),
  constraint calendars_parent_id_fkey foreign key (parent_id) references auth.users (id) on update cascade on delete set null
) tablespace pg_default;

ALTER TABLE public.calendars ENABLE ROW LEVEL SECURITY;

CREATE POLICY all_rls_calendars
ON public.calendars
to authenticated, service_role
USING (
    (( SELECT uid() AS uid) = parent_id)
);

create table
public.checkups (
id uuid not null default gen_random_uuid (),
child_id uuid null,
parent_id uuid null default uid (),
inspector_id uuid null,
weight numeric not null,
head_circumference numeric not null,
height numeric not null,
diagnosis character varying null,
action character varying null,
complaint character varying null,
updated_at timestamp with time zone null,
created_at timestamp with time zone not null default now(),
deleted_at timestamp with time zone null,
vaccine_type character varying null,
month character varying null,
constraint checkups_pkey primary key (id),
constraint checkups_child_id_fkey foreign key (child_id) references children (id) on update cascade on delete set null,
constraint checkups_parent_id_fkey foreign key (parent_id) references auth.users (id) on update cascade on delete set null
) tablespace pg_default;

ALTER TABLE public.checkups ENABLE ROW LEVEL SECURITY;

CREATE POLICY all_rls_checkups
ON public.checkups
to authenticated, service_role
USING (
    (( SELECT uid() AS uid) = parent_id) OR
    (( SELECT uid() AS uid) = child_id) OR
    (( SELECT uid() AS uid) = inspector_id)
);

create table
public.notifications (
id uuid not null default gen_random_uuid (),
user_id uuid null default uid (),
title character varying not null,
body character varying not null,
is_read boolean not null default false,
created_at timestamp with time zone not null default now(),
updated_at timestamp with time zone null,
constraint notifications_pkey primary key (id),
constraint notifications_user_id_fkey foreign key (user_id) references auth.users (id) on update cascade on delete set null
) tablespace pg_default;

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY all_rls_notifications
ON public.notifications
to authenticated, service_role
USING (true);

-- migrate:down
DROP POLICY IF EXISTS all_rls_appointments ON public.appointments CASCADE;
DROP POLICY IF EXISTS all_rls_blog_tags ON public.blog_tags CASCADE;
DROP POLICY IF EXISTS all_rls_blogs ON public.blogs CASCADE;
DROP POLICY IF EXISTS all_rls_calendars ON public.calendars CASCADE;
DROP POLICY IF EXISTS all_rls_checkups ON public.checkups CASCADE;
DROP POLICY IF EXISTS all_rls_notifications ON public.notifications CASCADE;
DROP POLICY IF EXISTS "Enable delete for children based on parent_id" ON public.children CASCADE;
DROP POLICY IF EXISTS "Enable insert for children based on parent_id" ON public.children CASCADE;
DROP POLICY IF EXISTS "Enable update for children based on parent_id" ON public.children CASCADE;
DROP POLICY IF EXISTS "Enable select for children based on parent_id" ON public.children CASCADE;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON public.profiles CASCADE;
DROP POLICY IF EXISTS "Enable update for authenticated users only" ON public.profiles CASCADE;
DROP POLICY IF EXISTS "Enable select for authenticated and service role users only" ON public.profiles CASCADE;

ALTER TABLE public.appointments DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.blog_tags DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.blogs DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.calendars DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.checkups DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.children DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles DISABLE ROW LEVEL SECURITY;

DROP TABLE IF EXISTS public.appointments CASCADE;
DROP TABLE IF EXISTS public.blog_tags CASCADE;
DROP TABLE IF EXISTS public.blogs CASCADE;
DROP TABLE IF EXISTS public.calendars CASCADE;
DROP TABLE IF EXISTS public.checkups CASCADE;
DROP TABLE IF EXISTS public.children CASCADE;
DROP TABLE IF EXISTS public.notifications CASCADE;
DROP TABLE IF EXISTS public.profiles CASCADE;

DROP FUNCTION IF EXISTS public.handle_new_user() CASCADE;
DROP FUNCTION IF EXISTS public.handle_new_user_2() CASCADE;

DROP TYPE IF EXISTS public.blood_type CASCADE;
DROP TYPE IF EXISTS public.gender_type CASCADE;