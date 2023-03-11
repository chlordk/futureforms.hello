--
-- PostgreSQL database dump
--

-- Dumped from database version 14.7 (Ubuntu 14.7-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.7 (Ubuntu 14.7-0ubuntu0.22.04.1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: countries; Type: TABLE; Schema: public; Owner: hello
--

CREATE TABLE public.countries (
    country_id character(2) NOT NULL,
    country_name character varying(40)
);


ALTER TABLE public.countries OWNER TO hello;

--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: hello
--

COPY public.countries (country_id, country_name) FROM stdin;
DK	Denmark
FI	Finland
SE	Sweden
CN	People's Republic of China
UK	United Kingdom
NO	Norway
BO	Bolivia
\.


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: hello
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (country_id);


--
-- PostgreSQL database dump complete
--

