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
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: delivery_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.delivery_status AS ENUM (
    'new',
    'processing',
    'delivered',
    'cancelled'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: couriers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.couriers (
    name character varying NOT NULL,
    email character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    id uuid DEFAULT public.gen_random_uuid() NOT NULL
);


--
-- Name: packages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.packages (
    tracking_number character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    courier_id uuid NOT NULL,
    delivery_status public.delivery_status DEFAULT 'new'::public.delivery_status NOT NULL,
    estimated_delivery_time timestamp without time zone DEFAULT (now() + '01:00:00'::interval) NOT NULL,
    CONSTRAINT check_tracking_number CHECK (((tracking_number)::text ~ similar_escape('%YA[0-9]{8}AA%'::text, NULL::text)))
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: couriers couriers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.couriers
    ADD CONSTRAINT couriers_pkey PRIMARY KEY (id);


--
-- Name: packages packages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.packages
    ADD CONSTRAINT packages_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: index_couriers_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_couriers_on_created_at ON public.couriers USING btree (created_at);


--
-- Name: index_couriers_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_couriers_on_email ON public.couriers USING btree (email);


--
-- Name: index_packages_on_courier_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_packages_on_courier_id ON public.packages USING btree (courier_id);


--
-- Name: index_packages_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_packages_on_created_at ON public.packages USING btree (created_at);


--
-- Name: index_packages_on_tracking_number; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_packages_on_tracking_number ON public.packages USING btree (tracking_number);


--
-- Name: packages fk_rails_180ae67646; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.packages
    ADD CONSTRAINT fk_rails_180ae67646 FOREIGN KEY (courier_id) REFERENCES public.couriers(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20210730200147'),
('20210730201320'),
('20210731112246'),
('20210731141801'),
('20210917165626'),
('20210917171827'),
('20210918101501'),
('20210921195410'),
('20210924172341');


