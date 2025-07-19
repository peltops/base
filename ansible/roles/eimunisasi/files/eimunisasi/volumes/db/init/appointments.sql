create table
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
    constraint appointments_parent_id_fkey foreign key (parent_id) references users (id) on update cascade on delete set null,
    constraint appointments_child_id_fkey foreign key (child_id) references children (id) on update cascade on delete set null,
    constraint appointments_parent_id_fkey1 foreign key (parent_id) references profiles (user_id)
  ) tablespace pg_default;

ALTER TABLE public.appointments ENABLE ROW LEVEL SECURITY;

CREATE POLICY all_rls_appointments
ON public.appointments
to authenticated, service_role
USING (true);