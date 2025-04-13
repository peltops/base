--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1 (Ubuntu 15.1-1.pgdg20.04+1)
-- Dumped by pg_dump version 15.7 (Ubuntu 15.7-1.pgdg20.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: blood_type; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.blood_type AS ENUM (
    'A',
    'B',
    'AB',
    'O'
);


ALTER TYPE public.blood_type OWNER TO supabase_admin;

--
-- Name: gender_type; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.gender_type AS ENUM (
    'MALE',
    'FEMALE'
);


ALTER TYPE public.gender_type OWNER TO supabase_admin;

--
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql
    AS $$begin
  insert into public.profiles (user_id, avatar_url)
  values (new.id, new.raw_user_meta_data->>'avatar_url');
  return new;
end;$$;


ALTER FUNCTION public.handle_new_user() OWNER TO supabase_admin;

--
-- Name: handle_new_user_2(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.handle_new_user_2() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.profiles WHERE user_id = new.id) THEN
    INSERT INTO public.profiles (user_id, avatar_url, father_name)
    VALUES (new.id, new.raw_user_meta_data->>'avatar_url', new.raw_user_meta_data->>'full_name');
  END IF;
  RETURN new;
END;$$;


ALTER FUNCTION public.handle_new_user_2() OWNER TO supabase_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: appointments; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.appointments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    parent_id uuid,
    child_id uuid,
    inspector_id uuid,
    note character varying,
    date timestamp with time zone NOT NULL,
    purpose character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL
);


ALTER TABLE public.appointments OWNER TO supabase_admin;

--
-- Name: blog_tags; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.blog_tags (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.blog_tags OWNER TO supabase_admin;

--
-- Name: blogs; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.blogs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title character varying NOT NULL,
    body text NOT NULL,
    tag_id uuid NOT NULL,
    author character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE public.blogs OWNER TO supabase_admin;

--
-- Name: calendars; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.calendars (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    parent_id uuid DEFAULT auth.uid(),
    activity character varying NOT NULL,
    do_at timestamp with time zone NOT NULL,
    read_only boolean DEFAULT false NOT NULL
);


ALTER TABLE public.calendars OWNER TO supabase_admin;

--
-- Name: checkups; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.checkups (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    child_id uuid DEFAULT gen_random_uuid(),
    parent_id uuid DEFAULT auth.uid(),
    inspector_id uuid DEFAULT gen_random_uuid(),
    weight numeric NOT NULL,
    head_circumference numeric NOT NULL,
    height numeric NOT NULL,
    diagnosis character varying,
    action character varying,
    complaint character varying,
    updated_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    vaccine_type character varying,
    month character varying
);


ALTER TABLE public.checkups OWNER TO supabase_admin;

--
-- Name: children; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.children (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    parent_id uuid DEFAULT auth.uid(),
    nik character varying NOT NULL,
    name character varying NOT NULL,
    blood_type public.blood_type NOT NULL,
    gender public.gender_type NOT NULL,
    avatar_url text,
    date_of_birth date NOT NULL,
    place_of_birth character varying NOT NULL
);


ALTER TABLE public.children OWNER TO supabase_admin;

--
-- Name: countries; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.countries (
    id bigint NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.countries OWNER TO supabase_admin;

--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.countries ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.notifications (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid DEFAULT auth.uid(),
    title character varying NOT NULL,
    body character varying NOT NULL,
    is_read boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE public.notifications OWNER TO supabase_admin;

--
-- Name: private_posts; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.private_posts (
    id integer NOT NULL,
    content text NOT NULL
);


ALTER TABLE public.private_posts OWNER TO supabase_admin;

--
-- Name: private_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.private_posts ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.private_posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.profiles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    updated_at timestamp with time zone,
    avatar_url text,
    place_of_birth character varying,
    date_of_birth date,
    no_induk_kependudukan character varying,
    no_kartu_keluarga character varying,
    address text,
    father_name character varying,
    mother_name character varying,
    father_blood_type public.blood_type,
    mother_blood_type public.blood_type,
    father_phone_number character varying,
    mother_phone_number character varying,
    father_job character varying,
    mother_job character varying,
    user_id uuid DEFAULT auth.uid()
);


ALTER TABLE public.profiles OWNER TO supabase_admin;

--
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (id);


--
-- Name: blog_tags blog_tags_name_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.blog_tags
    ADD CONSTRAINT blog_tags_name_key UNIQUE (name);


--
-- Name: blog_tags blog_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.blog_tags
    ADD CONSTRAINT blog_tags_pkey PRIMARY KEY (id);


--
-- Name: blogs blogs_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.blogs
    ADD CONSTRAINT blogs_pkey PRIMARY KEY (id);


--
-- Name: calendars calendars_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.calendars
    ADD CONSTRAINT calendars_pkey PRIMARY KEY (id);


--
-- Name: checkups checkups_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.checkups
    ADD CONSTRAINT checkups_pkey PRIMARY KEY (id);


--
-- Name: children children_nik_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.children
    ADD CONSTRAINT children_nik_key UNIQUE (nik);


--
-- Name: children children_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.children
    ADD CONSTRAINT children_pkey PRIMARY KEY (id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: private_posts private_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.private_posts
    ADD CONSTRAINT private_posts_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_user_id_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_user_id_key UNIQUE (user_id);


--
-- Name: appointments appointments_child_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_child_id_fkey FOREIGN KEY (child_id) REFERENCES public.children(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: appointments appointments_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: appointments appointments_parent_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_parent_id_fkey1 FOREIGN KEY (parent_id) REFERENCES public.profiles(user_id);


--
-- Name: blogs blogs_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.blogs
    ADD CONSTRAINT blogs_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.blog_tags(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: calendars calendars_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.calendars
    ADD CONSTRAINT calendars_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: checkups checkups_child_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.checkups
    ADD CONSTRAINT checkups_child_id_fkey FOREIGN KEY (child_id) REFERENCES public.children(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: checkups checkups_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.checkups
    ADD CONSTRAINT checkups_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: children children_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.children
    ADD CONSTRAINT children_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: profiles profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: children Enable delete for children based on parent_id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable delete for children based on parent_id" ON public.children FOR DELETE TO authenticated USING ((( SELECT auth.uid() AS uid) = parent_id));


--
-- Name: profiles Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable insert for authenticated users only" ON public.profiles FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: children Enable insert for children based on parent_id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable insert for children based on parent_id" ON public.children FOR INSERT TO authenticated WITH CHECK ((( SELECT auth.uid() AS uid) = parent_id));


--
-- Name: children Enable read access; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable read access" ON public.children FOR SELECT TO authenticated USING ((( SELECT auth.uid() AS uid) = parent_id));


--
-- Name: children Enable update for children based on parent_id; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable update for children based on parent_id" ON public.children FOR UPDATE TO authenticated USING ((( SELECT auth.uid() AS uid) = parent_id)) WITH CHECK ((( SELECT auth.uid() AS uid) = parent_id));


--
-- Name: checkups Must same UID and authenticated; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Must same UID and authenticated" ON public.checkups TO authenticated USING ((( SELECT auth.uid() AS uid) = parent_id));


--
-- Name: profiles Public profiles are viewable by everyone.; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Public profiles are viewable by everyone." ON public.profiles FOR SELECT USING (true);


--
-- Name: profiles Users can update own profile.; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Users can update own profile." ON public.profiles FOR UPDATE USING ((( SELECT auth.uid() AS uid) = user_id));


--
-- Name: private_posts Users can view private_posts if they have signed in via MFA; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Users can view private_posts if they have signed in via MFA" ON public.private_posts FOR SELECT TO authenticated USING ((( SELECT (auth.jwt() ->> 'aal'::text)) = 'aal2'::text));


--
-- Name: blog_tags; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.blog_tags ENABLE ROW LEVEL SECURITY;

--
-- Name: blogs; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.blogs ENABLE ROW LEVEL SECURITY;

--
-- Name: calendars; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.calendars ENABLE ROW LEVEL SECURITY;

--
-- Name: calendars check uid = parent_id for all; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "check uid = parent_id for all" ON public.calendars TO authenticated USING ((( SELECT auth.uid() AS uid) = parent_id));


--
-- Name: checkups; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.checkups ENABLE ROW LEVEL SECURITY;

--
-- Name: children; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.children ENABLE ROW LEVEL SECURITY;

--
-- Name: countries; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.countries ENABLE ROW LEVEL SECURITY;

--
-- Name: notifications; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

--
-- Name: private_posts; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.private_posts ENABLE ROW LEVEL SECURITY;

--
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: countries public can read countries; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "public can read countries" ON public.countries FOR SELECT TO anon USING (true);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: FUNCTION handle_new_user(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.handle_new_user() TO postgres;
GRANT ALL ON FUNCTION public.handle_new_user() TO anon;
GRANT ALL ON FUNCTION public.handle_new_user() TO authenticated;
GRANT ALL ON FUNCTION public.handle_new_user() TO service_role;


--
-- Name: FUNCTION handle_new_user_2(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.handle_new_user_2() TO postgres;
GRANT ALL ON FUNCTION public.handle_new_user_2() TO anon;
GRANT ALL ON FUNCTION public.handle_new_user_2() TO authenticated;
GRANT ALL ON FUNCTION public.handle_new_user_2() TO service_role;


--
-- Name: TABLE appointments; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.appointments TO postgres;
GRANT ALL ON TABLE public.appointments TO anon;
GRANT ALL ON TABLE public.appointments TO authenticated;
GRANT ALL ON TABLE public.appointments TO service_role;


--
-- Name: TABLE blog_tags; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.blog_tags TO postgres;
GRANT ALL ON TABLE public.blog_tags TO anon;
GRANT ALL ON TABLE public.blog_tags TO authenticated;
GRANT ALL ON TABLE public.blog_tags TO service_role;


--
-- Name: TABLE blogs; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.blogs TO postgres;
GRANT ALL ON TABLE public.blogs TO anon;
GRANT ALL ON TABLE public.blogs TO authenticated;
GRANT ALL ON TABLE public.blogs TO service_role;


--
-- Name: TABLE calendars; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.calendars TO postgres;
GRANT ALL ON TABLE public.calendars TO anon;
GRANT ALL ON TABLE public.calendars TO authenticated;
GRANT ALL ON TABLE public.calendars TO service_role;


--
-- Name: TABLE checkups; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.checkups TO postgres;
GRANT ALL ON TABLE public.checkups TO anon;
GRANT ALL ON TABLE public.checkups TO authenticated;
GRANT ALL ON TABLE public.checkups TO service_role;


--
-- Name: TABLE children; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.children TO postgres;
GRANT ALL ON TABLE public.children TO anon;
GRANT ALL ON TABLE public.children TO authenticated;
GRANT ALL ON TABLE public.children TO service_role;


--
-- Name: TABLE countries; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.countries TO postgres;
GRANT ALL ON TABLE public.countries TO anon;
GRANT ALL ON TABLE public.countries TO authenticated;
GRANT ALL ON TABLE public.countries TO service_role;


--
-- Name: SEQUENCE countries_id_seq; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE public.countries_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.countries_id_seq TO anon;
GRANT ALL ON SEQUENCE public.countries_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.countries_id_seq TO service_role;


--
-- Name: TABLE notifications; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.notifications TO postgres;
GRANT ALL ON TABLE public.notifications TO anon;
GRANT ALL ON TABLE public.notifications TO authenticated;
GRANT ALL ON TABLE public.notifications TO service_role;


--
-- Name: TABLE private_posts; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.private_posts TO postgres;
GRANT ALL ON TABLE public.private_posts TO anon;
GRANT ALL ON TABLE public.private_posts TO authenticated;
GRANT ALL ON TABLE public.private_posts TO service_role;


--
-- Name: SEQUENCE private_posts_id_seq; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE public.private_posts_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.private_posts_id_seq TO anon;
GRANT ALL ON SEQUENCE public.private_posts_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.private_posts_id_seq TO service_role;


--
-- Name: TABLE profiles; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.profiles TO postgres;
GRANT ALL ON TABLE public.profiles TO anon;
GRANT ALL ON TABLE public.profiles TO authenticated;
GRANT ALL ON TABLE public.profiles TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO service_role;


--
-- PostgreSQL database dump complete
--

