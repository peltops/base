create table
public.calendars (
  id uuid not null default gen_random_uuid (),
  created_at timestamp with time zone not null default now(),
  parent_id uuid null default uid (),
  activity character varying not null,
  do_at timestamp with time zone not null,
  read_only boolean not null default false,
  constraint calendars_pkey primary key (id),
  constraint calendars_parent_id_fkey foreign key (parent_id) references users (id) on update cascade on delete set null
) tablespace pg_default;

ALTER TABLE public.calendars ENABLE ROW LEVEL SECURITY;

CREATE POLICY all_rls_calendars
ON public.calendars
to authenticated, service_role
USING (
    (( SELECT uid() AS uid) = parent_id)
);