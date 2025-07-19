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
constraint notifications_user_id_fkey foreign key (user_id) references users (id) on update cascade on delete set null
) tablespace pg_default;

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY all_rls_notifications
ON public.notifications
to authenticated, service_role
USING (true);