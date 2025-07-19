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

create table
public.blog_tags (
id uuid not null default gen_random_uuid (),
name character varying not null,
created_at timestamp with time zone not null default now(),
constraint blog_tags_pkey primary key (id),
constraint blog_tags_name_key unique (name)
) tablespace pg_default;

ALTER TABLE public.blogs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.blog_tags ENABLE ROW LEVEL SECURITY;

CREATE POLICY all_rls_blogs
ON public.blogs
to authenticated, service_role
USING (true);

CREATE POLICY all_rls_blog_tags
ON public.blog_tags
to authenticated, service_role
USING (true);