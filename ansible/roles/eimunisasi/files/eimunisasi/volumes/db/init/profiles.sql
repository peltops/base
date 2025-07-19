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
constraint profiles_user_id_fkey foreign key (user_id) references users (id) on update cascade on delete set null
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
  or
  (( SELECT uid() AS uid) = id)
);

CREATE policy "Enable select for authenticated and service role users only"
on "public"."profiles"
to authenticated, service_role
using (
    true
);