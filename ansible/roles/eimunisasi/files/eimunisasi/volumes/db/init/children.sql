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
    constraint children_parent_id_fkey foreign key (parent_id) references users (id) on update cascade on delete set null
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




