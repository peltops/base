create table
public.checkups (
id uuid not null default gen_random_uuid (),
child_id uuid null default gen_random_uuid (),
parent_id uuid null default uid (),
inspector_id uuid null default gen_random_uuid (),
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
constraint checkups_parent_id_fkey foreign key (parent_id) references users (id) on update cascade on delete set null
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