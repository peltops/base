-- migrate:up
create table if not exists public.profiles (
  id uuid not null default gen_random_uuid(),
  user_id uuid references auth.users on delete cascade,
  full_name text,
  avatar_url text,
  phone text,
  created_at timestamp with time zone default now() not null,
  updated_at timestamp with time zone default now() not null,
  primary key (id),
  constraint profiles_user_id_key unique (user_id)
);

alter table public.profiles enable row level security;

create policy "Users can view own profile"
  on public.profiles for select
  using (auth.uid() = user_id);

create policy "Users can update own profile"
  on public.profiles for update
  using (auth.uid() = user_id);

create or replace function public.handle_new_user()
returns trigger
language plpgsql security definer
as $$
begin
  if not exists (select 1 from public.profiles where user_id = new.id) then
    insert into public.profiles (user_id, avatar_url, full_name)
    values (new.id, new.raw_user_meta_data->>'avatar_url', new.raw_user_meta_data->>'full_name');
  end if;
  return new;
end;
$$;

create or replace trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- migrate:down
drop trigger if exists on_auth_user_created on auth.users;
drop function if exists public.handle_new_user();
drop table if exists public.profiles;
