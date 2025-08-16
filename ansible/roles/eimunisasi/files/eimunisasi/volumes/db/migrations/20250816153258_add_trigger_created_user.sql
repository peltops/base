-- migrate:up

-- delete function handle_new_user and handle_new_user_2 if they exist
drop function if exists public.handle_new_user cascade;
drop function if exists public.handle_new_user_2 cascade;

--
-- Name: handle_new_user(); Type: FUNCTION; Schema: public;
--
CREATE OR REPLACE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.profiles WHERE user_id = new.id) THEN
    INSERT INTO public.profiles (user_id, avatar_url, father_name)
    VALUES (new.id, new.raw_user_meta_data->>'avatar_url', new.raw_user_meta_data->>'full_name');
  END IF;
  RETURN new;
END;$$;

-- create trigger on_auth_user_created
-- This trigger will call the handle_new_user function after a new user is created
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- migrate:down
drop trigger on_auth_user_created on auth.users;
drop function if exists public.handle_new_user cascade;
