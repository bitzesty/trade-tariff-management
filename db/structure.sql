--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.14
-- Dumped by pg_dump version 9.6.13

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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: reassign_owned(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.reassign_owned() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
	begin
		-- do not execute if member of rds_superuser
		IF EXISTS (select 1 from pg_catalog.pg_roles where rolname = 'rds_superuser')
		AND pg_has_role(current_user, 'rds_superuser', 'member') THEN
			RETURN;
		END IF;

		-- do not execute if not member of manager role
		IF NOT pg_has_role(current_user, 'rdsbroker_7f53a659_8eed_49ba_b1cc_e36b227b84cd_manager', 'member') THEN
			RETURN;
		END IF;

		-- do not execute if superuser
		IF EXISTS (SELECT 1 FROM pg_user WHERE usename = current_user and usesuper = true) THEN
			RETURN;
		END IF;

		EXECUTE 'reassign owned by "' || current_user || '" to "rdsbroker_7f53a659_8eed_49ba_b1cc_e36b227b84cd_manager"';
	end
	$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: additional_code_description_periods_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.additional_code_description_periods_oplog (
    additional_code_description_period_sid integer,
    additional_code_sid integer,
    additional_code_type_id character varying(1),
    additional_code character varying(3),
    validity_start_date timestamp without time zone,
    created_at timestamp without time zone,
    validity_end_date timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer,
    added_by_id integer,
    added_at timestamp without time zone,
    "national" boolean
);


--
-- Name: additional_code_description_periods; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.additional_code_description_periods AS
 SELECT additional_code_description_periods1.additional_code_description_period_sid,
    additional_code_description_periods1.additional_code_sid,
    additional_code_description_periods1.additional_code_type_id,
    additional_code_description_periods1.additional_code,
    additional_code_description_periods1.validity_start_date,
    additional_code_description_periods1.validity_end_date,
    additional_code_description_periods1.oid,
    additional_code_description_periods1.operation,
    additional_code_description_periods1.operation_date,
    additional_code_description_periods1.status,
    additional_code_description_periods1.workbasket_id,
    additional_code_description_periods1.workbasket_sequence_number,
    additional_code_description_periods1.added_by_id,
    additional_code_description_periods1.added_at,
    additional_code_description_periods1."national"
   FROM public.additional_code_description_periods_oplog additional_code_description_periods1
  WHERE ((additional_code_description_periods1.oid IN ( SELECT max(additional_code_description_periods2.oid) AS max
           FROM public.additional_code_description_periods_oplog additional_code_description_periods2
          WHERE ((additional_code_description_periods1.additional_code_description_period_sid = additional_code_description_periods2.additional_code_description_period_sid) AND (additional_code_description_periods1.additional_code_sid = additional_code_description_periods2.additional_code_sid) AND ((additional_code_description_periods1.additional_code_type_id)::text = (additional_code_description_periods2.additional_code_type_id)::text)))) AND ((additional_code_description_periods1.operation)::text <> 'D'::text));


--
-- Name: additional_code_description_periods_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.additional_code_description_periods_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: additional_code_description_periods_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.additional_code_description_periods_oid_seq OWNED BY public.additional_code_description_periods_oplog.oid;


--
-- Name: additional_code_descriptions_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.additional_code_descriptions_oplog (
    additional_code_description_period_sid integer,
    language_id character varying(5),
    additional_code_sid integer,
    additional_code_type_id character varying(1),
    additional_code character varying(3),
    description text,
    created_at timestamp without time zone,
    "national" boolean,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer,
    added_by_id integer,
    added_at timestamp without time zone
);


--
-- Name: additional_code_descriptions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.additional_code_descriptions AS
 SELECT additional_code_descriptions1.additional_code_description_period_sid,
    additional_code_descriptions1.language_id,
    additional_code_descriptions1.additional_code_sid,
    additional_code_descriptions1.additional_code_type_id,
    additional_code_descriptions1.additional_code,
    additional_code_descriptions1.description,
    additional_code_descriptions1."national",
    additional_code_descriptions1.oid,
    additional_code_descriptions1.operation,
    additional_code_descriptions1.operation_date,
    additional_code_descriptions1.status,
    additional_code_descriptions1.workbasket_id,
    additional_code_descriptions1.workbasket_sequence_number,
    additional_code_descriptions1.added_by_id,
    additional_code_descriptions1.added_at
   FROM public.additional_code_descriptions_oplog additional_code_descriptions1
  WHERE ((additional_code_descriptions1.oid IN ( SELECT max(additional_code_descriptions2.oid) AS max
           FROM public.additional_code_descriptions_oplog additional_code_descriptions2
          WHERE ((additional_code_descriptions1.additional_code_description_period_sid = additional_code_descriptions2.additional_code_description_period_sid) AND (additional_code_descriptions1.additional_code_sid = additional_code_descriptions2.additional_code_sid)))) AND ((additional_code_descriptions1.operation)::text <> 'D'::text));


--
-- Name: additional_code_descriptions_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.additional_code_descriptions_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: additional_code_descriptions_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.additional_code_descriptions_oid_seq OWNED BY public.additional_code_descriptions_oplog.oid;


--
-- Name: additional_code_type_descriptions_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.additional_code_type_descriptions_oplog (
    additional_code_type_id character varying(1),
    language_id character varying(5),
    description text,
    created_at timestamp without time zone,
    "national" boolean,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: additional_code_type_descriptions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.additional_code_type_descriptions AS
 SELECT additional_code_type_descriptions1.additional_code_type_id,
    additional_code_type_descriptions1.language_id,
    additional_code_type_descriptions1.description,
    additional_code_type_descriptions1."national",
    additional_code_type_descriptions1.oid,
    additional_code_type_descriptions1.operation,
    additional_code_type_descriptions1.operation_date,
    additional_code_type_descriptions1.status,
    additional_code_type_descriptions1.workbasket_id,
    additional_code_type_descriptions1.workbasket_sequence_number
   FROM public.additional_code_type_descriptions_oplog additional_code_type_descriptions1
  WHERE ((additional_code_type_descriptions1.oid IN ( SELECT max(additional_code_type_descriptions2.oid) AS max
           FROM public.additional_code_type_descriptions_oplog additional_code_type_descriptions2
          WHERE ((additional_code_type_descriptions1.additional_code_type_id)::text = (additional_code_type_descriptions2.additional_code_type_id)::text))) AND ((additional_code_type_descriptions1.operation)::text <> 'D'::text));


--
-- Name: additional_code_type_descriptions_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.additional_code_type_descriptions_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: additional_code_type_descriptions_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.additional_code_type_descriptions_oid_seq OWNED BY public.additional_code_type_descriptions_oplog.oid;


--
-- Name: additional_code_type_measure_types_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.additional_code_type_measure_types_oplog (
    measure_type_id character varying(3),
    additional_code_type_id character varying(1),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    created_at timestamp without time zone,
    "national" boolean,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: additional_code_type_measure_types; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.additional_code_type_measure_types AS
 SELECT additional_code_type_measure_types1.measure_type_id,
    additional_code_type_measure_types1.additional_code_type_id,
    additional_code_type_measure_types1.validity_start_date,
    additional_code_type_measure_types1.validity_end_date,
    additional_code_type_measure_types1."national",
    additional_code_type_measure_types1.oid,
    additional_code_type_measure_types1.operation,
    additional_code_type_measure_types1.operation_date,
    additional_code_type_measure_types1.status,
    additional_code_type_measure_types1.workbasket_id,
    additional_code_type_measure_types1.workbasket_sequence_number
   FROM public.additional_code_type_measure_types_oplog additional_code_type_measure_types1
  WHERE ((additional_code_type_measure_types1.oid IN ( SELECT max(additional_code_type_measure_types2.oid) AS max
           FROM public.additional_code_type_measure_types_oplog additional_code_type_measure_types2
          WHERE (((additional_code_type_measure_types1.measure_type_id)::text = (additional_code_type_measure_types2.measure_type_id)::text) AND ((additional_code_type_measure_types1.additional_code_type_id)::text = (additional_code_type_measure_types2.additional_code_type_id)::text)))) AND ((additional_code_type_measure_types1.operation)::text <> 'D'::text));


--
-- Name: additional_code_type_measure_types_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.additional_code_type_measure_types_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: additional_code_type_measure_types_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.additional_code_type_measure_types_oid_seq OWNED BY public.additional_code_type_measure_types_oplog.oid;


--
-- Name: additional_code_types_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.additional_code_types_oplog (
    additional_code_type_id character varying(1),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    application_code character varying(255),
    meursing_table_plan_id character varying(2),
    created_at timestamp without time zone,
    "national" boolean,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: additional_code_types; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.additional_code_types AS
 SELECT additional_code_types1.additional_code_type_id,
    additional_code_types1.validity_start_date,
    additional_code_types1.validity_end_date,
    additional_code_types1.application_code,
    additional_code_types1.meursing_table_plan_id,
    additional_code_types1."national",
    additional_code_types1.oid,
    additional_code_types1.operation,
    additional_code_types1.operation_date,
    additional_code_types1.status,
    additional_code_types1.workbasket_id,
    additional_code_types1.workbasket_sequence_number
   FROM public.additional_code_types_oplog additional_code_types1
  WHERE ((additional_code_types1.oid IN ( SELECT max(additional_code_types2.oid) AS max
           FROM public.additional_code_types_oplog additional_code_types2
          WHERE ((additional_code_types1.additional_code_type_id)::text = (additional_code_types2.additional_code_type_id)::text))) AND ((additional_code_types1.operation)::text <> 'D'::text));


--
-- Name: additional_code_types_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.additional_code_types_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: additional_code_types_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.additional_code_types_oid_seq OWNED BY public.additional_code_types_oplog.oid;


--
-- Name: additional_codes_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.additional_codes_oplog (
    additional_code_sid integer,
    additional_code_type_id character varying(1),
    additional_code character varying(3),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    created_at timestamp without time zone,
    "national" boolean,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer,
    added_by_id integer,
    added_at timestamp without time zone
);


--
-- Name: additional_codes; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.additional_codes AS
 SELECT additional_codes1.additional_code_sid,
    additional_codes1.additional_code_type_id,
    additional_codes1.additional_code,
    additional_codes1.validity_start_date,
    additional_codes1.validity_end_date,
    additional_codes1."national",
    additional_codes1.oid,
    additional_codes1.operation,
    additional_codes1.operation_date,
    additional_codes1.status,
    additional_codes1.workbasket_id,
    additional_codes1.workbasket_sequence_number,
    additional_codes1.added_by_id,
    additional_codes1.added_at
   FROM public.additional_codes_oplog additional_codes1
  WHERE ((additional_codes1.oid IN ( SELECT max(additional_codes2.oid) AS max
           FROM public.additional_codes_oplog additional_codes2
          WHERE (additional_codes1.additional_code_sid = additional_codes2.additional_code_sid))) AND ((additional_codes1.operation)::text <> 'D'::text));


--
-- Name: additional_codes_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.additional_codes_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: additional_codes_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.additional_codes_oid_seq OWNED BY public.additional_codes_oplog.oid;


--
-- Name: meursing_additional_codes_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.meursing_additional_codes_oplog (
    meursing_additional_code_sid integer,
    additional_code character varying(3),
    validity_start_date timestamp without time zone,
    created_at timestamp without time zone,
    validity_end_date timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer,
    added_by_id integer,
    added_at timestamp without time zone,
    "national" boolean
);


--
-- Name: meursing_additional_codes; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.meursing_additional_codes AS
 SELECT meursing_additional_codes1.meursing_additional_code_sid,
    meursing_additional_codes1.additional_code,
    meursing_additional_codes1.validity_start_date,
    meursing_additional_codes1.validity_end_date,
    meursing_additional_codes1.oid,
    meursing_additional_codes1.operation,
    meursing_additional_codes1.operation_date,
    meursing_additional_codes1.status,
    meursing_additional_codes1.workbasket_id,
    meursing_additional_codes1.workbasket_sequence_number,
    meursing_additional_codes1.added_by_id,
    meursing_additional_codes1.added_at,
    meursing_additional_codes1."national"
   FROM public.meursing_additional_codes_oplog meursing_additional_codes1
  WHERE ((meursing_additional_codes1.oid IN ( SELECT max(meursing_additional_codes2.oid) AS max
           FROM public.meursing_additional_codes_oplog meursing_additional_codes2
          WHERE (meursing_additional_codes1.meursing_additional_code_sid = meursing_additional_codes2.meursing_additional_code_sid))) AND ((meursing_additional_codes1.operation)::text <> 'D'::text));


--
-- Name: all_additional_codes; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.all_additional_codes AS
 SELECT meursing_additional_codes.meursing_additional_code_sid AS additional_code_sid,
    '7'::character varying AS additional_code_type_id,
    meursing_additional_codes.additional_code,
    NULL::text AS description,
    NULL::character varying AS language_id,
    meursing_additional_codes.validity_start_date,
    meursing_additional_codes.validity_end_date,
    meursing_additional_codes.operation_date,
    meursing_additional_codes.status,
    meursing_additional_codes.workbasket_id,
    meursing_additional_codes.added_by_id,
    meursing_additional_codes.added_at,
    meursing_additional_codes."national"
   FROM public.meursing_additional_codes
UNION
 SELECT additional_codes.additional_code_sid,
    additional_codes.additional_code_type_id,
    additional_codes.additional_code,
    additional_code_descriptions.description,
    additional_code_descriptions.language_id,
    additional_codes.validity_start_date,
    additional_codes.validity_end_date,
    additional_codes.operation_date,
    additional_codes.status,
    additional_codes.workbasket_id,
    additional_codes.added_by_id,
    additional_codes.added_at,
    additional_codes."national"
   FROM ((public.additional_codes
     JOIN ( SELECT additional_code_description_periods_1.additional_code_description_period_sid,
            additional_code_description_periods_1.additional_code_sid,
            additional_code_description_periods_1.additional_code_type_id,
            additional_code_description_periods_1.additional_code,
            additional_code_description_periods_1.validity_start_date,
            additional_code_description_periods_1.validity_end_date,
            additional_code_description_periods_1.oid,
            additional_code_description_periods_1.operation,
            additional_code_description_periods_1.operation_date,
            additional_code_description_periods_1.status,
            additional_code_description_periods_1.workbasket_id,
            additional_code_description_periods_1.workbasket_sequence_number,
            additional_code_description_periods_1.added_by_id,
            additional_code_description_periods_1.added_at,
            additional_code_description_periods_1."national"
           FROM public.additional_code_description_periods additional_code_description_periods_1
          WHERE (additional_code_description_periods_1.additional_code_description_period_sid IN ( SELECT max(additional_code_description_periods_2.additional_code_description_period_sid) AS max
                   FROM public.additional_code_description_periods additional_code_description_periods_2
                  GROUP BY additional_code_description_periods_2.additional_code_type_id, additional_code_description_periods_2.additional_code))) additional_code_description_periods ON (((additional_code_description_periods.additional_code_sid = additional_codes.additional_code_sid) AND ((additional_code_description_periods.additional_code_type_id)::text = (additional_codes.additional_code_type_id)::text) AND ((additional_code_description_periods.additional_code)::text = (additional_codes.additional_code)::text))))
     JOIN public.additional_code_descriptions ON ((additional_code_descriptions.additional_code_description_period_sid = additional_code_description_periods.additional_code_description_period_sid)));


--
-- Name: audits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audits (
    id integer NOT NULL,
    auditable_id integer NOT NULL,
    auditable_type text NOT NULL,
    action text NOT NULL,
    changes json NOT NULL,
    version integer NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: audits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.audits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.audits_id_seq OWNED BY public.audits.id;


--
-- Name: base_regulations_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.base_regulations_oplog (
    base_regulation_role integer,
    base_regulation_id character varying(255),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    community_code integer,
    regulation_group_id character varying(255),
    replacement_indicator integer,
    stopped_flag boolean,
    information_text text,
    approved_flag boolean,
    published_date date,
    officialjournal_number character varying(255),
    officialjournal_page integer,
    effective_end_date timestamp without time zone,
    antidumping_regulation_role integer,
    related_antidumping_regulation_id character varying(255),
    complete_abrogation_regulation_role integer,
    complete_abrogation_regulation_id character varying(255),
    explicit_abrogation_regulation_role integer,
    explicit_abrogation_regulation_id character varying(255),
    created_at timestamp without time zone,
    "national" boolean,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    added_by_id integer,
    added_at timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: base_regulations; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.base_regulations AS
 SELECT base_regulations1.base_regulation_role,
    base_regulations1.base_regulation_id,
    base_regulations1.validity_start_date,
    base_regulations1.validity_end_date,
    base_regulations1.community_code,
    base_regulations1.regulation_group_id,
    base_regulations1.replacement_indicator,
    base_regulations1.stopped_flag,
    base_regulations1.information_text,
    base_regulations1.approved_flag,
    base_regulations1.published_date,
    base_regulations1.officialjournal_number,
    base_regulations1.officialjournal_page,
    base_regulations1.effective_end_date,
    base_regulations1.antidumping_regulation_role,
    base_regulations1.related_antidumping_regulation_id,
    base_regulations1.complete_abrogation_regulation_role,
    base_regulations1.complete_abrogation_regulation_id,
    base_regulations1.explicit_abrogation_regulation_role,
    base_regulations1.explicit_abrogation_regulation_id,
    base_regulations1."national",
    base_regulations1.oid,
    base_regulations1.operation,
    base_regulations1.operation_date,
    base_regulations1.added_by_id,
    base_regulations1.added_at,
    base_regulations1.status,
    base_regulations1.workbasket_id,
    base_regulations1.workbasket_sequence_number
   FROM public.base_regulations_oplog base_regulations1
  WHERE ((base_regulations1.oid IN ( SELECT max(base_regulations2.oid) AS max
           FROM public.base_regulations_oplog base_regulations2
          WHERE (((base_regulations1.base_regulation_id)::text = (base_regulations2.base_regulation_id)::text) AND (base_regulations1.base_regulation_role = base_regulations2.base_regulation_role)))) AND ((base_regulations1.operation)::text <> 'D'::text));


--
-- Name: base_regulations_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.base_regulations_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: base_regulations_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.base_regulations_oid_seq OWNED BY public.base_regulations_oplog.oid;


--
-- Name: bulk_edit_of_additional_codes_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bulk_edit_of_additional_codes_settings (
    id integer NOT NULL,
    workbasket_id integer,
    main_step_settings_jsonb jsonb DEFAULT '{}'::jsonb,
    main_step_validation_passed boolean DEFAULT false,
    search_code text,
    initial_search_results_code text,
    initial_items_populated boolean DEFAULT false,
    batches_loaded jsonb DEFAULT '{}'::jsonb,
    additional_code_sids_jsonb jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: bulk_edit_of_additional_codes_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bulk_edit_of_additional_codes_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bulk_edit_of_additional_codes_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bulk_edit_of_additional_codes_settings_id_seq OWNED BY public.bulk_edit_of_additional_codes_settings.id;


--
-- Name: bulk_edit_of_measures_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bulk_edit_of_measures_settings (
    id integer NOT NULL,
    workbasket_id integer,
    main_step_settings_jsonb jsonb DEFAULT '{}'::jsonb,
    main_step_validation_passed boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    measure_sids_jsonb jsonb DEFAULT '{}'::jsonb,
    search_code text,
    initial_search_results_code text,
    all_batched_loaded boolean DEFAULT false,
    initial_items_populated boolean DEFAULT false,
    batches_loaded jsonb DEFAULT '{}'::jsonb
);


--
-- Name: bulk_edit_of_measures_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bulk_edit_of_measures_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bulk_edit_of_measures_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bulk_edit_of_measures_settings_id_seq OWNED BY public.bulk_edit_of_measures_settings.id;


--
-- Name: bulk_edit_of_quotas_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bulk_edit_of_quotas_settings (
    id integer NOT NULL,
    workbasket_id integer,
    main_step_settings_jsonb jsonb DEFAULT '{}'::jsonb,
    main_step_validation_passed boolean DEFAULT false,
    initial_search_results_code text,
    initial_items_populated boolean DEFAULT false,
    batches_loaded jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    initial_quota_sid integer,
    configure_quota_step_settings_jsonb jsonb DEFAULT '{}'::jsonb,
    conditions_footnotes_step_settings_jsonb jsonb DEFAULT '{}'::jsonb,
    configure_step_settings_jsonb jsonb DEFAULT '{}'::jsonb,
    configure_quota_step_validation_passed boolean DEFAULT false,
    conditions_footnotes_step_validation_passed boolean DEFAULT false,
    measure_sids_jsonb jsonb DEFAULT '{}'::jsonb,
    quota_period_sids_jsonb jsonb DEFAULT '{}'::jsonb,
    parent_quota_period_sids_jsonb jsonb DEFAULT '{}'::jsonb
);


--
-- Name: bulk_edit_of_quotas_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bulk_edit_of_quotas_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bulk_edit_of_quotas_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bulk_edit_of_quotas_settings_id_seq OWNED BY public.bulk_edit_of_quotas_settings.id;


--
-- Name: certificate_description_periods_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.certificate_description_periods_oplog (
    certificate_description_period_sid integer,
    certificate_type_code character varying(1),
    certificate_code character varying(3),
    validity_start_date timestamp without time zone,
    created_at timestamp without time zone,
    validity_end_date timestamp without time zone,
    "national" boolean,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer,
    added_by_id integer,
    added_at timestamp without time zone
);


--
-- Name: certificate_description_periods; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.certificate_description_periods AS
 SELECT certificate_description_periods1.certificate_description_period_sid,
    certificate_description_periods1.certificate_type_code,
    certificate_description_periods1.certificate_code,
    certificate_description_periods1.validity_start_date,
    certificate_description_periods1.validity_end_date,
    certificate_description_periods1."national",
    certificate_description_periods1.oid,
    certificate_description_periods1.operation,
    certificate_description_periods1.operation_date,
    certificate_description_periods1.status,
    certificate_description_periods1.workbasket_id,
    certificate_description_periods1.workbasket_sequence_number,
    certificate_description_periods1.added_by_id,
    certificate_description_periods1.added_at
   FROM public.certificate_description_periods_oplog certificate_description_periods1
  WHERE ((certificate_description_periods1.oid IN ( SELECT max(certificate_description_periods2.oid) AS max
           FROM public.certificate_description_periods_oplog certificate_description_periods2
          WHERE (certificate_description_periods1.certificate_description_period_sid = certificate_description_periods2.certificate_description_period_sid))) AND ((certificate_description_periods1.operation)::text <> 'D'::text));


--
-- Name: certificate_description_periods_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.certificate_description_periods_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: certificate_description_periods_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.certificate_description_periods_oid_seq OWNED BY public.certificate_description_periods_oplog.oid;


--
-- Name: certificate_descriptions_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.certificate_descriptions_oplog (
    certificate_description_period_sid integer,
    language_id character varying(5),
    certificate_type_code character varying(1),
    certificate_code character varying(3),
    description text,
    created_at timestamp without time zone,
    "national" boolean,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer,
    added_by_id integer,
    added_at timestamp without time zone
);


--
-- Name: certificate_descriptions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.certificate_descriptions AS
 SELECT certificate_descriptions1.certificate_description_period_sid,
    certificate_descriptions1.language_id,
    certificate_descriptions1.certificate_type_code,
    certificate_descriptions1.certificate_code,
    certificate_descriptions1.description,
    certificate_descriptions1."national",
    certificate_descriptions1.oid,
    certificate_descriptions1.operation,
    certificate_descriptions1.operation_date,
    certificate_descriptions1.status,
    certificate_descriptions1.workbasket_id,
    certificate_descriptions1.workbasket_sequence_number,
    certificate_descriptions1.added_by_id,
    certificate_descriptions1.added_at
   FROM public.certificate_descriptions_oplog certificate_descriptions1
  WHERE ((certificate_descriptions1.oid IN ( SELECT max(certificate_descriptions2.oid) AS max
           FROM public.certificate_descriptions_oplog certificate_descriptions2
          WHERE (certificate_descriptions1.certificate_description_period_sid = certificate_descriptions2.certificate_description_period_sid))) AND ((certificate_descriptions1.operation)::text <> 'D'::text));


--
-- Name: certificate_descriptions_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.certificate_descriptions_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: certificate_descriptions_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.certificate_descriptions_oid_seq OWNED BY public.certificate_descriptions_oplog.oid;


--
-- Name: certificate_type_descriptions_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.certificate_type_descriptions_oplog (
    certificate_type_code character varying(1),
    language_id character varying(5),
    description text,
    created_at timestamp without time zone,
    "national" boolean,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: certificate_type_descriptions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.certificate_type_descriptions AS
 SELECT certificate_type_descriptions1.certificate_type_code,
    certificate_type_descriptions1.language_id,
    certificate_type_descriptions1.description,
    certificate_type_descriptions1."national",
    certificate_type_descriptions1.oid,
    certificate_type_descriptions1.operation,
    certificate_type_descriptions1.operation_date,
    certificate_type_descriptions1.status,
    certificate_type_descriptions1.workbasket_id,
    certificate_type_descriptions1.workbasket_sequence_number
   FROM public.certificate_type_descriptions_oplog certificate_type_descriptions1
  WHERE ((certificate_type_descriptions1.oid IN ( SELECT max(certificate_type_descriptions2.oid) AS max
           FROM public.certificate_type_descriptions_oplog certificate_type_descriptions2
          WHERE ((certificate_type_descriptions1.certificate_type_code)::text = (certificate_type_descriptions2.certificate_type_code)::text))) AND ((certificate_type_descriptions1.operation)::text <> 'D'::text));


--
-- Name: certificate_type_descriptions_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.certificate_type_descriptions_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: certificate_type_descriptions_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.certificate_type_descriptions_oid_seq OWNED BY public.certificate_type_descriptions_oplog.oid;


--
-- Name: certificate_types_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.certificate_types_oplog (
    certificate_type_code character varying(1),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    created_at timestamp without time zone,
    "national" boolean,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: certificate_types; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.certificate_types AS
 SELECT certificate_types1.certificate_type_code,
    certificate_types1.validity_start_date,
    certificate_types1.validity_end_date,
    certificate_types1."national",
    certificate_types1.oid,
    certificate_types1.operation,
    certificate_types1.operation_date,
    certificate_types1.status,
    certificate_types1.workbasket_id,
    certificate_types1.workbasket_sequence_number
   FROM public.certificate_types_oplog certificate_types1
  WHERE ((certificate_types1.oid IN ( SELECT max(certificate_types2.oid) AS max
           FROM public.certificate_types_oplog certificate_types2
          WHERE ((certificate_types1.certificate_type_code)::text = (certificate_types2.certificate_type_code)::text))) AND ((certificate_types1.operation)::text <> 'D'::text));


--
-- Name: certificate_types_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.certificate_types_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: certificate_types_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.certificate_types_oid_seq OWNED BY public.certificate_types_oplog.oid;


--
-- Name: certificates_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.certificates_oplog (
    certificate_type_code character varying(1),
    certificate_code character varying(3),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    created_at timestamp without time zone,
    "national" boolean,
    national_abbrev text,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer,
    added_by_id integer,
    added_at timestamp without time zone
);


--
-- Name: certificates; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.certificates AS
 SELECT certificates1.certificate_type_code,
    certificates1.certificate_code,
    certificates1.validity_start_date,
    certificates1.validity_end_date,
    certificates1."national",
    certificates1.national_abbrev,
    certificates1.oid,
    certificates1.operation,
    certificates1.operation_date,
    certificates1.status,
    certificates1.workbasket_id,
    certificates1.workbasket_sequence_number,
    certificates1.added_by_id,
    certificates1.added_at
   FROM public.certificates_oplog certificates1
  WHERE ((certificates1.oid IN ( SELECT max(certificates2.oid) AS max
           FROM public.certificates_oplog certificates2
          WHERE (((certificates1.certificate_code)::text = (certificates2.certificate_code)::text) AND ((certificates1.certificate_type_code)::text = (certificates2.certificate_type_code)::text)))) AND ((certificates1.operation)::text <> 'D'::text));


--
-- Name: certificates_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.certificates_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: certificates_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.certificates_oid_seq OWNED BY public.certificates_oplog.oid;


--
-- Name: chapter_notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chapter_notes (
    id integer NOT NULL,
    section_id integer,
    chapter_id character varying(2),
    content text
);


--
-- Name: chapter_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chapter_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chapter_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chapter_notes_id_seq OWNED BY public.chapter_notes.id;


--
-- Name: chapters_sections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chapters_sections (
    goods_nomenclature_sid integer,
    section_id integer
);


--
-- Name: chief_comm; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chief_comm (
    fe_tsmp timestamp without time zone,
    amend_indicator character varying(1),
    cmdty_code character varying(12),
    le_tsmp timestamp without time zone,
    add_rlf_alwd_ind boolean,
    alcohol_cmdty boolean,
    audit_tsmp timestamp without time zone,
    chi_doti_rqd boolean,
    cmdty_bbeer boolean,
    cmdty_beer boolean,
    cmdty_euse_alwd boolean,
    cmdty_exp_rfnd boolean,
    cmdty_mdecln boolean,
    exp_lcnc_rqd boolean,
    ex_ec_scode_rqd boolean,
    full_dty_adval1 numeric(6,3),
    full_dty_adval2 numeric(6,3),
    full_dty_exch character varying(3),
    full_dty_spfc1 numeric(8,4),
    full_dty_spfc2 numeric(8,4),
    full_dty_ttype character varying(3),
    full_dty_uoq_c2 character varying(3),
    full_dty_uoq1 character varying(3),
    full_dty_uoq2 character varying(3),
    full_duty_type character varying(2),
    im_ec_score_rqd boolean,
    imp_exp_use boolean,
    nba_id character varying(6),
    perfume_cmdty boolean,
    rfa character varying(255),
    season_end integer,
    season_start integer,
    spv_code character varying(7),
    spv_xhdg boolean,
    uoq_code_cdu1 character varying(3),
    uoq_code_cdu2 character varying(3),
    uoq_code_cdu3 character varying(3),
    whse_cmdty boolean,
    wines_cmdty boolean,
    origin character varying(30)
);


--
-- Name: chief_country_code; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chief_country_code (
    chief_country_cd character varying(2),
    country_cd character varying(2)
);


--
-- Name: chief_country_group; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chief_country_group (
    chief_country_grp character varying(4),
    country_grp_region character varying(4),
    country_exclusions character varying(100)
);


--
-- Name: chief_duty_expression; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chief_duty_expression (
    id integer NOT NULL,
    adval1_rate boolean,
    adval2_rate boolean,
    spfc1_rate boolean,
    spfc2_rate boolean,
    duty_expression_id_spfc1 character varying(2),
    monetary_unit_code_spfc1 character varying(3),
    duty_expression_id_spfc2 character varying(2),
    monetary_unit_code_spfc2 character varying(3),
    duty_expression_id_adval1 character varying(2),
    monetary_unit_code_adval1 character varying(3),
    duty_expression_id_adval2 character varying(2),
    monetary_unit_code_adval2 character varying(3)
);


--
-- Name: chief_duty_expression_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chief_duty_expression_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chief_duty_expression_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chief_duty_expression_id_seq OWNED BY public.chief_duty_expression.id;


--
-- Name: chief_measure_type_adco; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chief_measure_type_adco (
    measure_group_code character varying(2),
    measure_type character varying(3),
    tax_type_code character varying(11),
    measure_type_id character varying(3),
    adtnl_cd_type_id character varying(1),
    adtnl_cd character varying(3),
    zero_comp integer
);


--
-- Name: chief_measure_type_cond; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chief_measure_type_cond (
    measure_group_code character varying(2),
    measure_type character varying(3),
    cond_cd character varying(1),
    comp_seq_no character varying(3),
    cert_type_cd character varying(1),
    cert_ref_no character varying(3),
    act_cd character varying(2)
);


--
-- Name: chief_measure_type_footnote; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chief_measure_type_footnote (
    id integer NOT NULL,
    measure_type_id character varying(3),
    footn_type_id character varying(2),
    footn_id character varying(3)
);


--
-- Name: chief_measure_type_footnote_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chief_measure_type_footnote_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chief_measure_type_footnote_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chief_measure_type_footnote_id_seq OWNED BY public.chief_measure_type_footnote.id;


--
-- Name: chief_measurement_unit; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chief_measurement_unit (
    id integer NOT NULL,
    spfc_cmpd_uoq character varying(3),
    spfc_uoq character varying(3),
    measurem_unit_cd character varying(3),
    measurem_unit_qual_cd character varying(1)
);


--
-- Name: chief_measurement_unit_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chief_measurement_unit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chief_measurement_unit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chief_measurement_unit_id_seq OWNED BY public.chief_measurement_unit.id;


--
-- Name: chief_mfcm; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chief_mfcm (
    fe_tsmp timestamp without time zone,
    msrgp_code character varying(5),
    msr_type character varying(5),
    tty_code character varying(5),
    le_tsmp timestamp without time zone,
    audit_tsmp timestamp without time zone,
    cmdty_code character varying(12),
    cmdty_msr_xhdg character varying(255),
    null_tri_rqd character varying(255),
    exports_use_ind boolean,
    tar_msr_no character varying(12),
    processed boolean DEFAULT false,
    amend_indicator character varying(1),
    origin character varying(30)
);


--
-- Name: chief_tame; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chief_tame (
    fe_tsmp timestamp without time zone,
    msrgp_code character varying(5),
    msr_type character varying(5),
    tty_code character varying(5),
    tar_msr_no character varying(12),
    le_tsmp timestamp without time zone,
    adval_rate numeric(8,3),
    alch_sgth numeric(8,3),
    audit_tsmp timestamp without time zone,
    cap_ai_stmt character varying(255),
    cap_max_pct numeric(8,3),
    cmdty_msr_xhdg character varying(255),
    comp_mthd character varying(255),
    cpc_wvr_phb character varying(255),
    ec_msr_set character varying(255),
    mip_band_exch character varying(255),
    mip_rate_exch character varying(255),
    mip_uoq_code character varying(255),
    nba_id character varying(255),
    null_tri_rqd character varying(255),
    qta_code_uk character varying(255),
    qta_elig_use character varying(255),
    qta_exch_rate character varying(255),
    qta_no character varying(255),
    qta_uoq_code character varying(255),
    rfa text,
    rfs_code_1 character varying(255),
    rfs_code_2 character varying(255),
    rfs_code_3 character varying(255),
    rfs_code_4 character varying(255),
    rfs_code_5 character varying(255),
    tdr_spr_sur character varying(255),
    exports_use_ind boolean,
    processed boolean DEFAULT false,
    amend_indicator character varying(1),
    origin character varying(30),
    ec_sctr character varying(10)
);


--
-- Name: chief_tamf; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chief_tamf (
    fe_tsmp timestamp without time zone,
    msrgp_code character varying(5),
    msr_type character varying(5),
    tty_code character varying(5),
    tar_msr_no character varying(12),
    adval1_rate numeric(8,3),
    adval2_rate numeric(8,3),
    ai_factor character varying(255),
    cmdty_dmql numeric(8,3),
    cmdty_dmql_uoq character varying(255),
    cngp_code character varying(255),
    cntry_disp character varying(255),
    cntry_orig character varying(255),
    duty_type character varying(255),
    ec_supplement character varying(255),
    ec_exch_rate character varying(255),
    spcl_inst character varying(255),
    spfc1_cmpd_uoq character varying(255),
    spfc1_rate numeric(8,4),
    spfc1_uoq character varying(255),
    spfc2_rate numeric(8,4),
    spfc2_uoq character varying(255),
    spfc3_rate numeric(8,4),
    spfc3_uoq character varying(255),
    tamf_dt character varying(255),
    tamf_sta character varying(255),
    tamf_ty character varying(255),
    processed boolean DEFAULT false,
    amend_indicator character varying(1),
    origin character varying(30)
);


--
-- Name: chief_tbl9; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chief_tbl9 (
    fe_tsmp timestamp without time zone,
    amend_indicator character varying(1),
    tbl_type character varying(4),
    tbl_code character varying(10),
    txtlnno integer,
    tbl_txt character varying(100),
    origin character varying(30)
);


--
-- Name: complete_abrogation_regulations_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.complete_abrogation_regulations_oplog (
    complete_abrogation_regulation_role integer,
    complete_abrogation_regulation_id character varying(255),
    published_date date,
    officialjournal_number character varying(255),
    officialjournal_page integer,
    replacement_indicator integer,
    information_text text,
    approved_flag boolean,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    added_by_id integer,
    added_at timestamp without time zone,
    "national" boolean,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: complete_abrogation_regulations; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.complete_abrogation_regulations AS
 SELECT complete_abrogation_regulations1.complete_abrogation_regulation_role,
    complete_abrogation_regulations1.complete_abrogation_regulation_id,
    complete_abrogation_regulations1.published_date,
    complete_abrogation_regulations1.officialjournal_number,
    complete_abrogation_regulations1.officialjournal_page,
    complete_abrogation_regulations1.replacement_indicator,
    complete_abrogation_regulations1.information_text,
    complete_abrogation_regulations1.approved_flag,
    complete_abrogation_regulations1.oid,
    complete_abrogation_regulations1.operation,
    complete_abrogation_regulations1.operation_date,
    complete_abrogation_regulations1.added_by_id,
    complete_abrogation_regulations1.added_at,
    complete_abrogation_regulations1."national",
    complete_abrogation_regulations1.status,
    complete_abrogation_regulations1.workbasket_id,
    complete_abrogation_regulations1.workbasket_sequence_number
   FROM public.complete_abrogation_regulations_oplog complete_abrogation_regulations1
  WHERE ((complete_abrogation_regulations1.oid IN ( SELECT max(complete_abrogation_regulations2.oid) AS max
           FROM public.complete_abrogation_regulations_oplog complete_abrogation_regulations2
          WHERE (((complete_abrogation_regulations1.complete_abrogation_regulation_id)::text = (complete_abrogation_regulations2.complete_abrogation_regulation_id)::text) AND (complete_abrogation_regulations1.complete_abrogation_regulation_role = complete_abrogation_regulations2.complete_abrogation_regulation_role)))) AND ((complete_abrogation_regulations1.operation)::text <> 'D'::text));


--
-- Name: complete_abrogation_regulations_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.complete_abrogation_regulations_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: complete_abrogation_regulations_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.complete_abrogation_regulations_oid_seq OWNED BY public.complete_abrogation_regulations_oplog.oid;


--
-- Name: create_additional_code_workbasket_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.create_additional_code_workbasket_settings (
    id integer NOT NULL,
    workbasket_id integer,
    main_step_settings_jsonb jsonb DEFAULT '{}'::jsonb,
    main_step_validation_passed boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: create_additional_code_workbasket_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.create_additional_code_workbasket_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: create_additional_code_workbasket_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.create_additional_code_workbasket_settings_id_seq OWNED BY public.create_additional_code_workbasket_settings.id;


--
-- Name: create_certificates_workbasket_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.create_certificates_workbasket_settings (
    id integer NOT NULL,
    workbasket_id integer,
    main_step_settings_jsonb jsonb DEFAULT '{}'::jsonb,
    main_step_validation_passed boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: create_certificates_workbasket_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.create_certificates_workbasket_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: create_certificates_workbasket_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.create_certificates_workbasket_settings_id_seq OWNED BY public.create_certificates_workbasket_settings.id;


--
-- Name: create_footnotes_workbasket_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.create_footnotes_workbasket_settings (
    id integer NOT NULL,
    workbasket_id integer,
    main_step_settings_jsonb jsonb DEFAULT '{}'::jsonb,
    main_step_validation_passed boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: create_footnotes_workbasket_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.create_footnotes_workbasket_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: create_footnotes_workbasket_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.create_footnotes_workbasket_settings_id_seq OWNED BY public.create_footnotes_workbasket_settings.id;


--
-- Name: create_geographical_area_workbasket_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.create_geographical_area_workbasket_settings (
    id integer NOT NULL,
    workbasket_id integer,
    main_step_settings_jsonb jsonb DEFAULT '{}'::jsonb,
    main_step_validation_passed boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: create_geographical_area_workbasket_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.create_geographical_area_workbasket_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: create_geographical_area_workbasket_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.create_geographical_area_workbasket_settings_id_seq OWNED BY public.create_geographical_area_workbasket_settings.id;


--
-- Name: create_measures_workbasket_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.create_measures_workbasket_settings (
    id integer NOT NULL,
    workbasket_id integer,
    main_step_settings_jsonb jsonb DEFAULT '{}'::jsonb,
    created_at time without time zone,
    updated_at time without time zone,
    duties_conditions_footnotes_step_settings_jsonb jsonb DEFAULT '{}'::jsonb,
    main_step_validation_passed boolean DEFAULT false,
    duties_conditions_footnotes_step_validation_passed boolean DEFAULT false,
    measure_sids_jsonb jsonb DEFAULT '{}'::jsonb
);


--
-- Name: create_measures_workbasket_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.create_measures_workbasket_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: create_measures_workbasket_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.create_measures_workbasket_settings_id_seq OWNED BY public.create_measures_workbasket_settings.id;


--
-- Name: create_nomenclature_workbasket_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.create_nomenclature_workbasket_settings (
    id integer NOT NULL,
    workbasket_id integer,
    workbasket_name text,
    reason_for_changes text,
    parent_nomenclature_sid text,
    validity_start_date date,
    goods_nomenclature_item_id text,
    description text,
    producline_suffix text,
    number_indents integer,
    origin_nomenclature text,
    origin_producline_suffix text,
    main_step_validation_passed boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: create_nomenclature_workbasket_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.create_nomenclature_workbasket_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: create_nomenclature_workbasket_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.create_nomenclature_workbasket_settings_id_seq OWNED BY public.create_nomenclature_workbasket_settings.id;


--
-- Name: create_quota_association_workbasket_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.create_quota_association_workbasket_settings (
    id integer NOT NULL,
    workbasket_id integer,
    parent_quota_order_id text,
    child_quota_order_id text,
    parent_quota_definition_period text,
    child_quota_definition_period text,
    relation_type text,
    coefficient text,
    main_step_validation_passed boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: create_quota_association_workbasket_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.create_quota_association_workbasket_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: create_quota_association_workbasket_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.create_quota_association_workbasket_settings_id_seq OWNED BY public.create_quota_association_workbasket_settings.id;


--
-- Name: create_quota_blocking_period_workbasket_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.create_quota_blocking_period_workbasket_settings (
    id integer NOT NULL,
    workbasket_id integer,
    description text,
    start_date date,
    end_date date,
    quota_order_number_id text,
    quota_definition_sid text,
    quota_blocking_period_sid text,
    blocking_period_type text,
    main_step_validation_passed boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: create_quota_blocking_period_workbasket_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.create_quota_blocking_period_workbasket_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: create_quota_blocking_period_workbasket_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.create_quota_blocking_period_workbasket_settings_id_seq OWNED BY public.create_quota_blocking_period_workbasket_settings.id;


--
-- Name: create_quota_suspension_workbasket_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.create_quota_suspension_workbasket_settings (
    id integer NOT NULL,
    workbasket_id integer,
    description text,
    start_date date,
    end_date date,
    quota_order_number_id text,
    main_step_validation_passed boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: create_quota_suspension_workbasket_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.create_quota_suspension_workbasket_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: create_quota_suspension_workbasket_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.create_quota_suspension_workbasket_settings_id_seq OWNED BY public.create_quota_suspension_workbasket_settings.id;


--
-- Name: create_quota_workbasket_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.create_quota_workbasket_settings (
    id integer NOT NULL,
    workbasket_id integer,
    settings_jsonb jsonb DEFAULT '{}'::jsonb,
    measure_sids_jsonb jsonb DEFAULT '{}'::jsonb,
    quota_period_sids_jsonb jsonb DEFAULT '{}'::jsonb,
    main_step_validation_passed boolean DEFAULT false,
    configure_quota_step_validation_passed boolean DEFAULT false,
    conditions_footnotes_step_validation_passed boolean DEFAULT false,
    created_at time without time zone,
    updated_at time without time zone,
    main_step_settings_jsonb jsonb DEFAULT '{}'::jsonb,
    configure_quota_step_settings_jsonb jsonb DEFAULT '{}'::jsonb,
    conditions_footnotes_step_settings_jsonb jsonb DEFAULT '{}'::jsonb,
    parent_quota_period_sids_jsonb jsonb DEFAULT '{}'::jsonb,
    initial_quota_sid integer,
    initial_search_results_code text
);


--
-- Name: create_quota_workbasket_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.create_quota_workbasket_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: create_quota_workbasket_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.create_quota_workbasket_settings_id_seq OWNED BY public.create_quota_workbasket_settings.id;


--
-- Name: create_regulation_workbasket_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.create_regulation_workbasket_settings (
    id integer NOT NULL,
    workbasket_id integer,
    main_step_settings_jsonb jsonb DEFAULT '{}'::jsonb,
    main_step_validation_passed boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: create_regulation_workbasket_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.create_regulation_workbasket_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: create_regulation_workbasket_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.create_regulation_workbasket_settings_id_seq OWNED BY public.create_regulation_workbasket_settings.id;


--
-- Name: data_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.data_migrations (
    filename text NOT NULL
);


--
-- Name: db_rollbacks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.db_rollbacks (
    id integer NOT NULL,
    state character varying(1),
    issue_date timestamp without time zone,
    updated_at timestamp without time zone,
    created_at timestamp without time zone,
    date_filters text
);


--
-- Name: db_rollbacks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.db_rollbacks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: db_rollbacks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.db_rollbacks_id_seq OWNED BY public.db_rollbacks.id;


--
-- Name: delete_quota_association_workbasket_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.delete_quota_association_workbasket_settings (
    id integer NOT NULL,
    workbasket_id integer,
    main_quota_definition_sid text,
    sub_quota_definition_sid text,
    main_step_validation_passed boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: delete_quota_association_workbasket_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.delete_quota_association_workbasket_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delete_quota_association_workbasket_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.delete_quota_association_workbasket_settings_id_seq OWNED BY public.delete_quota_association_workbasket_settings.id;


--
-- Name: delete_quota_blocking_period_workbasket_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.delete_quota_blocking_period_workbasket_settings (
    id integer NOT NULL,
    workbasket_id integer,
    quota_blocking_period_sid text,
    main_step_validation_passed boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: delete_quota_blocking_period_workbasket_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.delete_quota_blocking_period_workbasket_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delete_quota_blocking_period_workbasket_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.delete_quota_blocking_period_workbasket_settings_id_seq OWNED BY public.delete_quota_blocking_period_workbasket_settings.id;


--
-- Name: delete_quota_suspension_workbasket_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.delete_quota_suspension_workbasket_settings (
    id integer NOT NULL,
    workbasket_id integer,
    quota_suspension_period_sid text,
    main_step_validation_passed boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: delete_quota_suspension_workbasket_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.delete_quota_suspension_workbasket_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delete_quota_suspension_workbasket_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.delete_quota_suspension_workbasket_settings_id_seq OWNED BY public.delete_quota_suspension_workbasket_settings.id;


--
-- Name: duty_expression_descriptions_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.duty_expression_descriptions_oplog (
    duty_expression_id character varying(255),
    language_id character varying(5),
    description text,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: duty_expression_descriptions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.duty_expression_descriptions AS
 SELECT duty_expression_descriptions1.duty_expression_id,
    duty_expression_descriptions1.language_id,
    duty_expression_descriptions1.description,
    duty_expression_descriptions1.oid,
    duty_expression_descriptions1.operation,
    duty_expression_descriptions1.operation_date,
    duty_expression_descriptions1.status,
    duty_expression_descriptions1.workbasket_id,
    duty_expression_descriptions1.workbasket_sequence_number
   FROM public.duty_expression_descriptions_oplog duty_expression_descriptions1
  WHERE ((duty_expression_descriptions1.oid IN ( SELECT max(duty_expression_descriptions2.oid) AS max
           FROM public.duty_expression_descriptions_oplog duty_expression_descriptions2
          WHERE ((duty_expression_descriptions1.duty_expression_id)::text = (duty_expression_descriptions2.duty_expression_id)::text))) AND ((duty_expression_descriptions1.operation)::text <> 'D'::text));


--
-- Name: duty_expression_descriptions_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.duty_expression_descriptions_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: duty_expression_descriptions_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.duty_expression_descriptions_oid_seq OWNED BY public.duty_expression_descriptions_oplog.oid;


--
-- Name: duty_expressions_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.duty_expressions_oplog (
    duty_expression_id character varying(255),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    duty_amount_applicability_code integer,
    measurement_unit_applicability_code integer,
    monetary_unit_applicability_code integer,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: duty_expressions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.duty_expressions AS
 SELECT duty_expressions1.duty_expression_id,
    duty_expressions1.validity_start_date,
    duty_expressions1.validity_end_date,
    duty_expressions1.duty_amount_applicability_code,
    duty_expressions1.measurement_unit_applicability_code,
    duty_expressions1.monetary_unit_applicability_code,
    duty_expressions1.oid,
    duty_expressions1.operation,
    duty_expressions1.operation_date,
    duty_expressions1.status,
    duty_expressions1.workbasket_id,
    duty_expressions1.workbasket_sequence_number
   FROM public.duty_expressions_oplog duty_expressions1
  WHERE ((duty_expressions1.oid IN ( SELECT max(duty_expressions2.oid) AS max
           FROM public.duty_expressions_oplog duty_expressions2
          WHERE ((duty_expressions1.duty_expression_id)::text = (duty_expressions2.duty_expression_id)::text))) AND ((duty_expressions1.operation)::text <> 'D'::text));


--
-- Name: duty_expressions_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.duty_expressions_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: duty_expressions_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.duty_expressions_oid_seq OWNED BY public.duty_expressions_oplog.oid;


--
-- Name: edit_certificates_workbasket_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.edit_certificates_workbasket_settings (
    id integer NOT NULL,
    workbasket_id integer,
    main_step_settings_jsonb jsonb DEFAULT '{}'::jsonb,
    main_step_validation_passed boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    original_certificate_type_code text,
    original_certificate_code text
);


--
-- Name: edit_certificates_workbasket_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.edit_certificates_workbasket_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: edit_certificates_workbasket_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.edit_certificates_workbasket_settings_id_seq OWNED BY public.edit_certificates_workbasket_settings.id;


--
-- Name: edit_footnotes_workbasket_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.edit_footnotes_workbasket_settings (
    id integer NOT NULL,
    workbasket_id integer,
    main_step_settings_jsonb jsonb DEFAULT '{}'::jsonb,
    main_step_validation_passed boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    original_footnote_type_id text,
    original_footnote_id text
);


--
-- Name: edit_footnotes_workbasket_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.edit_footnotes_workbasket_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: edit_footnotes_workbasket_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.edit_footnotes_workbasket_settings_id_seq OWNED BY public.edit_footnotes_workbasket_settings.id;


--
-- Name: edit_geographical_areas_workbasket_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.edit_geographical_areas_workbasket_settings (
    id integer NOT NULL,
    workbasket_id integer,
    main_step_settings_jsonb jsonb DEFAULT '{}'::jsonb,
    main_step_validation_passed boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    original_geographical_area_sid text,
    original_geographical_area_id text
);


--
-- Name: edit_geographical_areas_workbasket_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.edit_geographical_areas_workbasket_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: edit_geographical_areas_workbasket_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.edit_geographical_areas_workbasket_settings_id_seq OWNED BY public.edit_geographical_areas_workbasket_settings.id;


--
-- Name: edit_nomenclature_workbasket_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.edit_nomenclature_workbasket_settings (
    id integer NOT NULL,
    workbasket_id integer,
    workbasket_name text,
    reason_for_changes text,
    validity_start_date date,
    description text,
    original_nomenclature text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    main_step_validation_passed boolean DEFAULT false,
    original_description text
);


--
-- Name: edit_nomenclature_workbasket_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.edit_nomenclature_workbasket_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: edit_nomenclature_workbasket_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.edit_nomenclature_workbasket_settings_id_seq OWNED BY public.edit_nomenclature_workbasket_settings.id;


--
-- Name: edit_quota_blocking_period_workbasket_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.edit_quota_blocking_period_workbasket_settings (
    id integer NOT NULL,
    workbasket_id integer,
    description text,
    start_date date,
    end_date date,
    quota_order_number_id text,
    quota_definition_sid text,
    quota_blocking_period_sid text,
    blocking_period_type text,
    main_step_validation_passed boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: edit_quota_blocking_period_workbasket_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.edit_quota_blocking_period_workbasket_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: edit_quota_blocking_period_workbasket_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.edit_quota_blocking_period_workbasket_settings_id_seq OWNED BY public.edit_quota_blocking_period_workbasket_settings.id;


--
-- Name: edit_quota_suspension_workbasket_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.edit_quota_suspension_workbasket_settings (
    id integer NOT NULL,
    workbasket_id integer,
    description text,
    start_date date,
    end_date date,
    quota_order_number_id text,
    main_step_validation_passed boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    quota_definition_sid text,
    quota_suspension_period_sid text
);


--
-- Name: edit_quota_suspension_workbasket_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.edit_quota_suspension_workbasket_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: edit_quota_suspension_workbasket_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.edit_quota_suspension_workbasket_settings_id_seq OWNED BY public.edit_quota_suspension_workbasket_settings.id;


--
-- Name: edit_regulation_workbasket_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.edit_regulation_workbasket_settings (
    id integer NOT NULL,
    workbasket_id integer,
    reason_for_changes text,
    original_base_regulation_id text,
    original_base_regulation_role text,
    base_regulation_id text,
    legal_id text,
    description text,
    reference_url text,
    validity_start_date date,
    validity_end_date date,
    regulation_group_id text,
    main_step_validation_passed boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: edit_regulation_workbasket_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.edit_regulation_workbasket_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: edit_regulation_workbasket_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.edit_regulation_workbasket_settings_id_seq OWNED BY public.edit_regulation_workbasket_settings.id;


--
-- Name: explicit_abrogation_regulations_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.explicit_abrogation_regulations_oplog (
    explicit_abrogation_regulation_role integer,
    explicit_abrogation_regulation_id character varying(8),
    published_date date,
    officialjournal_number character varying(255),
    officialjournal_page integer,
    replacement_indicator integer,
    abrogation_date date,
    information_text text,
    approved_flag boolean,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    added_by_id integer,
    added_at timestamp without time zone,
    "national" boolean,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: explicit_abrogation_regulations; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.explicit_abrogation_regulations AS
 SELECT explicit_abrogation_regulations1.explicit_abrogation_regulation_role,
    explicit_abrogation_regulations1.explicit_abrogation_regulation_id,
    explicit_abrogation_regulations1.published_date,
    explicit_abrogation_regulations1.officialjournal_number,
    explicit_abrogation_regulations1.officialjournal_page,
    explicit_abrogation_regulations1.replacement_indicator,
    explicit_abrogation_regulations1.abrogation_date,
    explicit_abrogation_regulations1.information_text,
    explicit_abrogation_regulations1.approved_flag,
    explicit_abrogation_regulations1.oid,
    explicit_abrogation_regulations1.operation,
    explicit_abrogation_regulations1.operation_date,
    explicit_abrogation_regulations1.added_by_id,
    explicit_abrogation_regulations1.added_at,
    explicit_abrogation_regulations1."national",
    explicit_abrogation_regulations1.status,
    explicit_abrogation_regulations1.workbasket_id,
    explicit_abrogation_regulations1.workbasket_sequence_number
   FROM public.explicit_abrogation_regulations_oplog explicit_abrogation_regulations1
  WHERE ((explicit_abrogation_regulations1.oid IN ( SELECT max(explicit_abrogation_regulations2.oid) AS max
           FROM public.explicit_abrogation_regulations_oplog explicit_abrogation_regulations2
          WHERE (((explicit_abrogation_regulations1.explicit_abrogation_regulation_id)::text = (explicit_abrogation_regulations2.explicit_abrogation_regulation_id)::text) AND (explicit_abrogation_regulations1.explicit_abrogation_regulation_role = explicit_abrogation_regulations2.explicit_abrogation_regulation_role)))) AND ((explicit_abrogation_regulations1.operation)::text <> 'D'::text));


--
-- Name: explicit_abrogation_regulations_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.explicit_abrogation_regulations_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: explicit_abrogation_regulations_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.explicit_abrogation_regulations_oid_seq OWNED BY public.explicit_abrogation_regulations_oplog.oid;


--
-- Name: export_refund_nomenclature_description_periods_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.export_refund_nomenclature_description_periods_oplog (
    export_refund_nomenclature_description_period_sid integer,
    export_refund_nomenclature_sid integer,
    validity_start_date timestamp without time zone,
    goods_nomenclature_item_id character varying(10),
    additional_code_type text,
    export_refund_code character varying(255),
    productline_suffix character varying(2),
    created_at timestamp without time zone,
    validity_end_date timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: export_refund_nomenclature_description_periods; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.export_refund_nomenclature_description_periods AS
 SELECT export_refund_nomenclature_description_periods1.export_refund_nomenclature_description_period_sid,
    export_refund_nomenclature_description_periods1.export_refund_nomenclature_sid,
    export_refund_nomenclature_description_periods1.validity_start_date,
    export_refund_nomenclature_description_periods1.goods_nomenclature_item_id,
    export_refund_nomenclature_description_periods1.additional_code_type,
    export_refund_nomenclature_description_periods1.export_refund_code,
    export_refund_nomenclature_description_periods1.productline_suffix,
    export_refund_nomenclature_description_periods1.validity_end_date,
    export_refund_nomenclature_description_periods1.oid,
    export_refund_nomenclature_description_periods1.operation,
    export_refund_nomenclature_description_periods1.operation_date,
    export_refund_nomenclature_description_periods1.status,
    export_refund_nomenclature_description_periods1.workbasket_id,
    export_refund_nomenclature_description_periods1.workbasket_sequence_number
   FROM public.export_refund_nomenclature_description_periods_oplog export_refund_nomenclature_description_periods1
  WHERE ((export_refund_nomenclature_description_periods1.oid IN ( SELECT max(export_refund_nomenclature_description_periods2.oid) AS max
           FROM public.export_refund_nomenclature_description_periods_oplog export_refund_nomenclature_description_periods2
          WHERE ((export_refund_nomenclature_description_periods1.export_refund_nomenclature_sid = export_refund_nomenclature_description_periods2.export_refund_nomenclature_sid) AND (export_refund_nomenclature_description_periods1.export_refund_nomenclature_description_period_sid = export_refund_nomenclature_description_periods2.export_refund_nomenclature_description_period_sid)))) AND ((export_refund_nomenclature_description_periods1.operation)::text <> 'D'::text));


--
-- Name: export_refund_nomenclature_description_periods_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.export_refund_nomenclature_description_periods_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: export_refund_nomenclature_description_periods_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.export_refund_nomenclature_description_periods_oid_seq OWNED BY public.export_refund_nomenclature_description_periods_oplog.oid;


--
-- Name: export_refund_nomenclature_descriptions_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.export_refund_nomenclature_descriptions_oplog (
    export_refund_nomenclature_description_period_sid integer,
    language_id character varying(5),
    export_refund_nomenclature_sid integer,
    goods_nomenclature_item_id character varying(10),
    additional_code_type text,
    export_refund_code character varying(255),
    productline_suffix character varying(2),
    description text,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: export_refund_nomenclature_descriptions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.export_refund_nomenclature_descriptions AS
 SELECT export_refund_nomenclature_descriptions1.export_refund_nomenclature_description_period_sid,
    export_refund_nomenclature_descriptions1.language_id,
    export_refund_nomenclature_descriptions1.export_refund_nomenclature_sid,
    export_refund_nomenclature_descriptions1.goods_nomenclature_item_id,
    export_refund_nomenclature_descriptions1.additional_code_type,
    export_refund_nomenclature_descriptions1.export_refund_code,
    export_refund_nomenclature_descriptions1.productline_suffix,
    export_refund_nomenclature_descriptions1.description,
    export_refund_nomenclature_descriptions1.oid,
    export_refund_nomenclature_descriptions1.operation,
    export_refund_nomenclature_descriptions1.operation_date,
    export_refund_nomenclature_descriptions1.status,
    export_refund_nomenclature_descriptions1.workbasket_id,
    export_refund_nomenclature_descriptions1.workbasket_sequence_number
   FROM public.export_refund_nomenclature_descriptions_oplog export_refund_nomenclature_descriptions1
  WHERE ((export_refund_nomenclature_descriptions1.oid IN ( SELECT max(export_refund_nomenclature_descriptions2.oid) AS max
           FROM public.export_refund_nomenclature_descriptions_oplog export_refund_nomenclature_descriptions2
          WHERE (export_refund_nomenclature_descriptions1.export_refund_nomenclature_description_period_sid = export_refund_nomenclature_descriptions2.export_refund_nomenclature_description_period_sid))) AND ((export_refund_nomenclature_descriptions1.operation)::text <> 'D'::text));


--
-- Name: export_refund_nomenclature_descriptions_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.export_refund_nomenclature_descriptions_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: export_refund_nomenclature_descriptions_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.export_refund_nomenclature_descriptions_oid_seq OWNED BY public.export_refund_nomenclature_descriptions_oplog.oid;


--
-- Name: export_refund_nomenclature_indents_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.export_refund_nomenclature_indents_oplog (
    export_refund_nomenclature_indents_sid integer,
    export_refund_nomenclature_sid integer,
    validity_start_date timestamp without time zone,
    number_export_refund_nomenclature_indents integer,
    goods_nomenclature_item_id character varying(10),
    additional_code_type text,
    export_refund_code character varying(255),
    productline_suffix character varying(2),
    created_at timestamp without time zone,
    validity_end_date timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: export_refund_nomenclature_indents; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.export_refund_nomenclature_indents AS
 SELECT export_refund_nomenclature_indents1.export_refund_nomenclature_indents_sid,
    export_refund_nomenclature_indents1.export_refund_nomenclature_sid,
    export_refund_nomenclature_indents1.validity_start_date,
    export_refund_nomenclature_indents1.number_export_refund_nomenclature_indents,
    export_refund_nomenclature_indents1.goods_nomenclature_item_id,
    export_refund_nomenclature_indents1.additional_code_type,
    export_refund_nomenclature_indents1.export_refund_code,
    export_refund_nomenclature_indents1.productline_suffix,
    export_refund_nomenclature_indents1.validity_end_date,
    export_refund_nomenclature_indents1.oid,
    export_refund_nomenclature_indents1.operation,
    export_refund_nomenclature_indents1.operation_date,
    export_refund_nomenclature_indents1.status,
    export_refund_nomenclature_indents1.workbasket_id,
    export_refund_nomenclature_indents1.workbasket_sequence_number
   FROM public.export_refund_nomenclature_indents_oplog export_refund_nomenclature_indents1
  WHERE ((export_refund_nomenclature_indents1.oid IN ( SELECT max(export_refund_nomenclature_indents2.oid) AS max
           FROM public.export_refund_nomenclature_indents_oplog export_refund_nomenclature_indents2
          WHERE (export_refund_nomenclature_indents1.export_refund_nomenclature_indents_sid = export_refund_nomenclature_indents2.export_refund_nomenclature_indents_sid))) AND ((export_refund_nomenclature_indents1.operation)::text <> 'D'::text));


--
-- Name: export_refund_nomenclature_indents_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.export_refund_nomenclature_indents_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: export_refund_nomenclature_indents_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.export_refund_nomenclature_indents_oid_seq OWNED BY public.export_refund_nomenclature_indents_oplog.oid;


--
-- Name: export_refund_nomenclatures_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.export_refund_nomenclatures_oplog (
    export_refund_nomenclature_sid integer,
    goods_nomenclature_item_id character varying(10),
    additional_code_type character varying(1),
    export_refund_code character varying(3),
    productline_suffix character varying(2),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    goods_nomenclature_sid integer,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: export_refund_nomenclatures; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.export_refund_nomenclatures AS
 SELECT export_refund_nomenclatures1.export_refund_nomenclature_sid,
    export_refund_nomenclatures1.goods_nomenclature_item_id,
    export_refund_nomenclatures1.additional_code_type,
    export_refund_nomenclatures1.export_refund_code,
    export_refund_nomenclatures1.productline_suffix,
    export_refund_nomenclatures1.validity_start_date,
    export_refund_nomenclatures1.validity_end_date,
    export_refund_nomenclatures1.goods_nomenclature_sid,
    export_refund_nomenclatures1.oid,
    export_refund_nomenclatures1.operation,
    export_refund_nomenclatures1.operation_date,
    export_refund_nomenclatures1.status,
    export_refund_nomenclatures1.workbasket_id,
    export_refund_nomenclatures1.workbasket_sequence_number
   FROM public.export_refund_nomenclatures_oplog export_refund_nomenclatures1
  WHERE ((export_refund_nomenclatures1.oid IN ( SELECT max(export_refund_nomenclatures2.oid) AS max
           FROM public.export_refund_nomenclatures_oplog export_refund_nomenclatures2
          WHERE (export_refund_nomenclatures1.export_refund_nomenclature_sid = export_refund_nomenclatures2.export_refund_nomenclature_sid))) AND ((export_refund_nomenclatures1.operation)::text <> 'D'::text));


--
-- Name: export_refund_nomenclatures_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.export_refund_nomenclatures_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: export_refund_nomenclatures_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.export_refund_nomenclatures_oid_seq OWNED BY public.export_refund_nomenclatures_oplog.oid;


--
-- Name: footnote_association_additional_codes_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.footnote_association_additional_codes_oplog (
    additional_code_sid integer,
    footnote_type_id character varying(2),
    footnote_id character varying(5),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    additional_code_type_id text,
    additional_code character varying(3),
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: footnote_association_additional_codes; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.footnote_association_additional_codes AS
 SELECT footnote_association_additional_codes1.additional_code_sid,
    footnote_association_additional_codes1.footnote_type_id,
    footnote_association_additional_codes1.footnote_id,
    footnote_association_additional_codes1.validity_start_date,
    footnote_association_additional_codes1.validity_end_date,
    footnote_association_additional_codes1.additional_code_type_id,
    footnote_association_additional_codes1.additional_code,
    footnote_association_additional_codes1.oid,
    footnote_association_additional_codes1.operation,
    footnote_association_additional_codes1.operation_date,
    footnote_association_additional_codes1.status,
    footnote_association_additional_codes1.workbasket_id,
    footnote_association_additional_codes1.workbasket_sequence_number
   FROM public.footnote_association_additional_codes_oplog footnote_association_additional_codes1
  WHERE ((footnote_association_additional_codes1.oid IN ( SELECT max(footnote_association_additional_codes2.oid) AS max
           FROM public.footnote_association_additional_codes_oplog footnote_association_additional_codes2
          WHERE (((footnote_association_additional_codes1.footnote_id)::text = (footnote_association_additional_codes2.footnote_id)::text) AND ((footnote_association_additional_codes1.footnote_type_id)::text = (footnote_association_additional_codes2.footnote_type_id)::text) AND (footnote_association_additional_codes1.additional_code_sid = footnote_association_additional_codes2.additional_code_sid)))) AND ((footnote_association_additional_codes1.operation)::text <> 'D'::text));


--
-- Name: footnote_association_additional_codes_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.footnote_association_additional_codes_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: footnote_association_additional_codes_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.footnote_association_additional_codes_oid_seq OWNED BY public.footnote_association_additional_codes_oplog.oid;


--
-- Name: footnote_association_erns_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.footnote_association_erns_oplog (
    export_refund_nomenclature_sid integer,
    footnote_type character varying(2),
    footnote_id character varying(5),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    goods_nomenclature_item_id character varying(10),
    additional_code_type text,
    export_refund_code character varying(255),
    productline_suffix character varying(2),
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: footnote_association_erns; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.footnote_association_erns AS
 SELECT footnote_association_erns1.export_refund_nomenclature_sid,
    footnote_association_erns1.footnote_type,
    footnote_association_erns1.footnote_id,
    footnote_association_erns1.validity_start_date,
    footnote_association_erns1.validity_end_date,
    footnote_association_erns1.goods_nomenclature_item_id,
    footnote_association_erns1.additional_code_type,
    footnote_association_erns1.export_refund_code,
    footnote_association_erns1.productline_suffix,
    footnote_association_erns1.oid,
    footnote_association_erns1.operation,
    footnote_association_erns1.operation_date,
    footnote_association_erns1.status,
    footnote_association_erns1.workbasket_id,
    footnote_association_erns1.workbasket_sequence_number
   FROM public.footnote_association_erns_oplog footnote_association_erns1
  WHERE ((footnote_association_erns1.oid IN ( SELECT max(footnote_association_erns2.oid) AS max
           FROM public.footnote_association_erns_oplog footnote_association_erns2
          WHERE ((footnote_association_erns1.export_refund_nomenclature_sid = footnote_association_erns2.export_refund_nomenclature_sid) AND ((footnote_association_erns1.footnote_id)::text = (footnote_association_erns2.footnote_id)::text) AND ((footnote_association_erns1.footnote_type)::text = (footnote_association_erns2.footnote_type)::text) AND (footnote_association_erns1.validity_start_date = footnote_association_erns2.validity_start_date)))) AND ((footnote_association_erns1.operation)::text <> 'D'::text));


--
-- Name: footnote_association_erns_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.footnote_association_erns_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: footnote_association_erns_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.footnote_association_erns_oid_seq OWNED BY public.footnote_association_erns_oplog.oid;


--
-- Name: footnote_association_goods_nomenclatures_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.footnote_association_goods_nomenclatures_oplog (
    goods_nomenclature_sid integer,
    footnote_type character varying(2),
    footnote_id character varying(5),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    goods_nomenclature_item_id character varying(10),
    productline_suffix character varying(2),
    created_at timestamp without time zone,
    "national" boolean,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer,
    added_by_id integer,
    added_at timestamp without time zone
);


--
-- Name: footnote_association_goods_nomenclatures; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.footnote_association_goods_nomenclatures AS
 SELECT footnote_association_goods_nomenclatures1.goods_nomenclature_sid,
    footnote_association_goods_nomenclatures1.footnote_type,
    footnote_association_goods_nomenclatures1.footnote_id,
    footnote_association_goods_nomenclatures1.validity_start_date,
    footnote_association_goods_nomenclatures1.validity_end_date,
    footnote_association_goods_nomenclatures1.goods_nomenclature_item_id,
    footnote_association_goods_nomenclatures1.productline_suffix,
    footnote_association_goods_nomenclatures1."national",
    footnote_association_goods_nomenclatures1.oid,
    footnote_association_goods_nomenclatures1.operation,
    footnote_association_goods_nomenclatures1.operation_date,
    footnote_association_goods_nomenclatures1.status,
    footnote_association_goods_nomenclatures1.workbasket_id,
    footnote_association_goods_nomenclatures1.workbasket_sequence_number,
    footnote_association_goods_nomenclatures1.added_by_id,
    footnote_association_goods_nomenclatures1.added_at
   FROM public.footnote_association_goods_nomenclatures_oplog footnote_association_goods_nomenclatures1
  WHERE ((footnote_association_goods_nomenclatures1.oid IN ( SELECT max(footnote_association_goods_nomenclatures2.oid) AS max
           FROM public.footnote_association_goods_nomenclatures_oplog footnote_association_goods_nomenclatures2
          WHERE (((footnote_association_goods_nomenclatures1.footnote_id)::text = (footnote_association_goods_nomenclatures2.footnote_id)::text) AND ((footnote_association_goods_nomenclatures1.footnote_type)::text = (footnote_association_goods_nomenclatures2.footnote_type)::text) AND (footnote_association_goods_nomenclatures1.goods_nomenclature_sid = footnote_association_goods_nomenclatures2.goods_nomenclature_sid)))) AND ((footnote_association_goods_nomenclatures1.operation)::text <> 'D'::text));


--
-- Name: footnote_association_goods_nomenclatures_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.footnote_association_goods_nomenclatures_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: footnote_association_goods_nomenclatures_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.footnote_association_goods_nomenclatures_oid_seq OWNED BY public.footnote_association_goods_nomenclatures_oplog.oid;


--
-- Name: footnote_association_measures_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.footnote_association_measures_oplog (
    measure_sid integer,
    footnote_type_id character varying(2),
    footnote_id character varying(5),
    created_at timestamp without time zone,
    "national" boolean,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    added_by_id integer,
    added_at timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: footnote_association_measures; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.footnote_association_measures AS
 SELECT footnote_association_measures1.measure_sid,
    footnote_association_measures1.footnote_type_id,
    footnote_association_measures1.footnote_id,
    footnote_association_measures1."national",
    footnote_association_measures1.oid,
    footnote_association_measures1.operation,
    footnote_association_measures1.operation_date,
    footnote_association_measures1.added_by_id,
    footnote_association_measures1.added_at,
    footnote_association_measures1.status,
    footnote_association_measures1.workbasket_id,
    footnote_association_measures1.workbasket_sequence_number
   FROM public.footnote_association_measures_oplog footnote_association_measures1
  WHERE ((footnote_association_measures1.oid IN ( SELECT max(footnote_association_measures2.oid) AS max
           FROM public.footnote_association_measures_oplog footnote_association_measures2
          WHERE ((footnote_association_measures1.measure_sid = footnote_association_measures2.measure_sid) AND ((footnote_association_measures1.footnote_id)::text = (footnote_association_measures2.footnote_id)::text) AND ((footnote_association_measures1.footnote_type_id)::text = (footnote_association_measures2.footnote_type_id)::text)))) AND ((footnote_association_measures1.operation)::text <> 'D'::text));


--
-- Name: footnote_association_measures_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.footnote_association_measures_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: footnote_association_measures_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.footnote_association_measures_oid_seq OWNED BY public.footnote_association_measures_oplog.oid;


--
-- Name: footnote_association_meursing_headings_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.footnote_association_meursing_headings_oplog (
    meursing_table_plan_id character varying(2),
    meursing_heading_number character varying(255),
    row_column_code integer,
    footnote_type character varying(2),
    footnote_id character varying(5),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: footnote_association_meursing_headings; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.footnote_association_meursing_headings AS
 SELECT footnote_association_meursing_headings1.meursing_table_plan_id,
    footnote_association_meursing_headings1.meursing_heading_number,
    footnote_association_meursing_headings1.row_column_code,
    footnote_association_meursing_headings1.footnote_type,
    footnote_association_meursing_headings1.footnote_id,
    footnote_association_meursing_headings1.validity_start_date,
    footnote_association_meursing_headings1.validity_end_date,
    footnote_association_meursing_headings1.oid,
    footnote_association_meursing_headings1.operation,
    footnote_association_meursing_headings1.operation_date,
    footnote_association_meursing_headings1.status,
    footnote_association_meursing_headings1.workbasket_id,
    footnote_association_meursing_headings1.workbasket_sequence_number
   FROM public.footnote_association_meursing_headings_oplog footnote_association_meursing_headings1
  WHERE ((footnote_association_meursing_headings1.oid IN ( SELECT max(footnote_association_meursing_headings2.oid) AS max
           FROM public.footnote_association_meursing_headings_oplog footnote_association_meursing_headings2
          WHERE (((footnote_association_meursing_headings1.footnote_id)::text = (footnote_association_meursing_headings2.footnote_id)::text) AND ((footnote_association_meursing_headings1.meursing_table_plan_id)::text = (footnote_association_meursing_headings2.meursing_table_plan_id)::text)))) AND ((footnote_association_meursing_headings1.operation)::text <> 'D'::text));


--
-- Name: footnote_association_meursing_headings_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.footnote_association_meursing_headings_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: footnote_association_meursing_headings_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.footnote_association_meursing_headings_oid_seq OWNED BY public.footnote_association_meursing_headings_oplog.oid;


--
-- Name: footnote_description_periods_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.footnote_description_periods_oplog (
    footnote_description_period_sid integer,
    footnote_type_id character varying(2),
    footnote_id character varying(5),
    validity_start_date timestamp without time zone,
    created_at timestamp without time zone,
    validity_end_date timestamp without time zone,
    "national" boolean,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    added_by_id integer,
    added_at timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: footnote_description_periods; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.footnote_description_periods AS
 SELECT footnote_description_periods1.footnote_description_period_sid,
    footnote_description_periods1.footnote_type_id,
    footnote_description_periods1.footnote_id,
    footnote_description_periods1.validity_start_date,
    footnote_description_periods1.validity_end_date,
    footnote_description_periods1."national",
    footnote_description_periods1.oid,
    footnote_description_periods1.operation,
    footnote_description_periods1.operation_date,
    footnote_description_periods1.added_by_id,
    footnote_description_periods1.added_at,
    footnote_description_periods1.status,
    footnote_description_periods1.workbasket_id,
    footnote_description_periods1.workbasket_sequence_number
   FROM public.footnote_description_periods_oplog footnote_description_periods1
  WHERE ((footnote_description_periods1.oid IN ( SELECT max(footnote_description_periods2.oid) AS max
           FROM public.footnote_description_periods_oplog footnote_description_periods2
          WHERE (((footnote_description_periods1.footnote_id)::text = (footnote_description_periods2.footnote_id)::text) AND ((footnote_description_periods1.footnote_type_id)::text = (footnote_description_periods2.footnote_type_id)::text) AND (footnote_description_periods1.footnote_description_period_sid = footnote_description_periods2.footnote_description_period_sid)))) AND ((footnote_description_periods1.operation)::text <> 'D'::text));


--
-- Name: footnote_description_periods_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.footnote_description_periods_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: footnote_description_periods_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.footnote_description_periods_oid_seq OWNED BY public.footnote_description_periods_oplog.oid;


--
-- Name: footnote_descriptions_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.footnote_descriptions_oplog (
    footnote_description_period_sid integer,
    footnote_type_id character varying(2),
    footnote_id character varying(5),
    language_id character varying(5),
    description text,
    created_at timestamp without time zone,
    "national" boolean,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    added_by_id integer,
    added_at timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: footnote_descriptions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.footnote_descriptions AS
 SELECT footnote_descriptions1.footnote_description_period_sid,
    footnote_descriptions1.footnote_type_id,
    footnote_descriptions1.footnote_id,
    footnote_descriptions1.language_id,
    footnote_descriptions1.description,
    footnote_descriptions1."national",
    footnote_descriptions1.oid,
    footnote_descriptions1.operation,
    footnote_descriptions1.operation_date,
    footnote_descriptions1.added_by_id,
    footnote_descriptions1.added_at,
    footnote_descriptions1.status,
    footnote_descriptions1.workbasket_id,
    footnote_descriptions1.workbasket_sequence_number
   FROM public.footnote_descriptions_oplog footnote_descriptions1
  WHERE ((footnote_descriptions1.oid IN ( SELECT max(footnote_descriptions2.oid) AS max
           FROM public.footnote_descriptions_oplog footnote_descriptions2
          WHERE ((footnote_descriptions1.footnote_description_period_sid = footnote_descriptions2.footnote_description_period_sid) AND ((footnote_descriptions1.footnote_id)::text = (footnote_descriptions2.footnote_id)::text) AND ((footnote_descriptions1.footnote_type_id)::text = (footnote_descriptions2.footnote_type_id)::text)))) AND ((footnote_descriptions1.operation)::text <> 'D'::text));


--
-- Name: footnote_descriptions_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.footnote_descriptions_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: footnote_descriptions_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.footnote_descriptions_oid_seq OWNED BY public.footnote_descriptions_oplog.oid;


--
-- Name: footnote_type_descriptions_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.footnote_type_descriptions_oplog (
    footnote_type_id character varying(2),
    language_id character varying(5),
    description text,
    created_at timestamp without time zone,
    "national" boolean,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: footnote_type_descriptions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.footnote_type_descriptions AS
 SELECT footnote_type_descriptions1.footnote_type_id,
    footnote_type_descriptions1.language_id,
    footnote_type_descriptions1.description,
    footnote_type_descriptions1."national",
    footnote_type_descriptions1.oid,
    footnote_type_descriptions1.operation,
    footnote_type_descriptions1.operation_date,
    footnote_type_descriptions1.status,
    footnote_type_descriptions1.workbasket_id,
    footnote_type_descriptions1.workbasket_sequence_number
   FROM public.footnote_type_descriptions_oplog footnote_type_descriptions1
  WHERE ((footnote_type_descriptions1.oid IN ( SELECT max(footnote_type_descriptions2.oid) AS max
           FROM public.footnote_type_descriptions_oplog footnote_type_descriptions2
          WHERE ((footnote_type_descriptions1.footnote_type_id)::text = (footnote_type_descriptions2.footnote_type_id)::text))) AND ((footnote_type_descriptions1.operation)::text <> 'D'::text));


--
-- Name: footnote_type_descriptions_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.footnote_type_descriptions_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: footnote_type_descriptions_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.footnote_type_descriptions_oid_seq OWNED BY public.footnote_type_descriptions_oplog.oid;


--
-- Name: footnote_types_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.footnote_types_oplog (
    footnote_type_id character varying(2),
    application_code integer,
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    created_at timestamp without time zone,
    "national" boolean,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: footnote_types; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.footnote_types AS
 SELECT footnote_types1.footnote_type_id,
    footnote_types1.application_code,
    footnote_types1.validity_start_date,
    footnote_types1.validity_end_date,
    footnote_types1."national",
    footnote_types1.oid,
    footnote_types1.operation,
    footnote_types1.operation_date,
    footnote_types1.status,
    footnote_types1.workbasket_id,
    footnote_types1.workbasket_sequence_number
   FROM public.footnote_types_oplog footnote_types1
  WHERE ((footnote_types1.oid IN ( SELECT max(footnote_types2.oid) AS max
           FROM public.footnote_types_oplog footnote_types2
          WHERE ((footnote_types1.footnote_type_id)::text = (footnote_types2.footnote_type_id)::text))) AND ((footnote_types1.operation)::text <> 'D'::text));


--
-- Name: footnote_types_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.footnote_types_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: footnote_types_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.footnote_types_oid_seq OWNED BY public.footnote_types_oplog.oid;


--
-- Name: footnotes_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.footnotes_oplog (
    footnote_id character varying(5),
    footnote_type_id character varying(2),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    created_at timestamp without time zone,
    "national" boolean,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    added_by_id integer,
    added_at timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: footnotes; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.footnotes AS
 SELECT footnotes1.footnote_id,
    footnotes1.footnote_type_id,
    footnotes1.validity_start_date,
    footnotes1.validity_end_date,
    footnotes1."national",
    footnotes1.oid,
    footnotes1.operation,
    footnotes1.operation_date,
    footnotes1.added_by_id,
    footnotes1.added_at,
    footnotes1.status,
    footnotes1.workbasket_id,
    footnotes1.workbasket_sequence_number
   FROM public.footnotes_oplog footnotes1
  WHERE ((footnotes1.oid IN ( SELECT max(footnotes2.oid) AS max
           FROM public.footnotes_oplog footnotes2
          WHERE (((footnotes1.footnote_type_id)::text = (footnotes2.footnote_type_id)::text) AND ((footnotes1.footnote_id)::text = (footnotes2.footnote_id)::text)))) AND ((footnotes1.operation)::text <> 'D'::text));


--
-- Name: footnotes_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.footnotes_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: footnotes_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.footnotes_oid_seq OWNED BY public.footnotes_oplog.oid;


--
-- Name: fts_regulation_actions_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fts_regulation_actions_oplog (
    fts_regulation_role integer,
    fts_regulation_id character varying(8),
    stopped_regulation_role integer,
    stopped_regulation_id character varying(8),
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: fts_regulation_actions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.fts_regulation_actions AS
 SELECT fts_regulation_actions1.fts_regulation_role,
    fts_regulation_actions1.fts_regulation_id,
    fts_regulation_actions1.stopped_regulation_role,
    fts_regulation_actions1.stopped_regulation_id,
    fts_regulation_actions1.oid,
    fts_regulation_actions1.operation,
    fts_regulation_actions1.operation_date,
    fts_regulation_actions1.status,
    fts_regulation_actions1.workbasket_id,
    fts_regulation_actions1.workbasket_sequence_number
   FROM public.fts_regulation_actions_oplog fts_regulation_actions1
  WHERE ((fts_regulation_actions1.oid IN ( SELECT max(fts_regulation_actions2.oid) AS max
           FROM public.fts_regulation_actions_oplog fts_regulation_actions2
          WHERE (((fts_regulation_actions1.fts_regulation_id)::text = (fts_regulation_actions2.fts_regulation_id)::text) AND (fts_regulation_actions1.fts_regulation_role = fts_regulation_actions2.fts_regulation_role) AND ((fts_regulation_actions1.stopped_regulation_id)::text = (fts_regulation_actions2.stopped_regulation_id)::text) AND (fts_regulation_actions1.stopped_regulation_role = fts_regulation_actions2.stopped_regulation_role)))) AND ((fts_regulation_actions1.operation)::text <> 'D'::text));


--
-- Name: fts_regulation_actions_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fts_regulation_actions_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fts_regulation_actions_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fts_regulation_actions_oid_seq OWNED BY public.fts_regulation_actions_oplog.oid;


--
-- Name: full_temporary_stop_regulations_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.full_temporary_stop_regulations_oplog (
    full_temporary_stop_regulation_role integer,
    full_temporary_stop_regulation_id character varying(8),
    published_date date,
    officialjournal_number character varying(255),
    officialjournal_page integer,
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    effective_enddate date,
    explicit_abrogation_regulation_role integer,
    explicit_abrogation_regulation_id character varying(8),
    replacement_indicator integer,
    information_text text,
    approved_flag boolean,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    added_by_id integer,
    added_at timestamp without time zone,
    "national" boolean,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer,
    complete_abrogation_regulation_role integer,
    complete_abrogation_regulation_id text
);


--
-- Name: full_temporary_stop_regulations; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.full_temporary_stop_regulations AS
 SELECT full_temporary_stop_regulations1.full_temporary_stop_regulation_role,
    full_temporary_stop_regulations1.full_temporary_stop_regulation_id,
    full_temporary_stop_regulations1.published_date,
    full_temporary_stop_regulations1.officialjournal_number,
    full_temporary_stop_regulations1.officialjournal_page,
    full_temporary_stop_regulations1.validity_start_date,
    full_temporary_stop_regulations1.validity_end_date,
    full_temporary_stop_regulations1.effective_enddate,
    full_temporary_stop_regulations1.explicit_abrogation_regulation_role,
    full_temporary_stop_regulations1.explicit_abrogation_regulation_id,
    full_temporary_stop_regulations1.replacement_indicator,
    full_temporary_stop_regulations1.information_text,
    full_temporary_stop_regulations1.approved_flag,
    full_temporary_stop_regulations1.oid,
    full_temporary_stop_regulations1.operation,
    full_temporary_stop_regulations1.operation_date,
    full_temporary_stop_regulations1.added_by_id,
    full_temporary_stop_regulations1.added_at,
    full_temporary_stop_regulations1."national",
    full_temporary_stop_regulations1.status,
    full_temporary_stop_regulations1.workbasket_id,
    full_temporary_stop_regulations1.workbasket_sequence_number,
    full_temporary_stop_regulations1.complete_abrogation_regulation_role,
    full_temporary_stop_regulations1.complete_abrogation_regulation_id
   FROM public.full_temporary_stop_regulations_oplog full_temporary_stop_regulations1
  WHERE ((full_temporary_stop_regulations1.oid IN ( SELECT max(full_temporary_stop_regulations2.oid) AS max
           FROM public.full_temporary_stop_regulations_oplog full_temporary_stop_regulations2
          WHERE (((full_temporary_stop_regulations1.full_temporary_stop_regulation_id)::text = (full_temporary_stop_regulations2.full_temporary_stop_regulation_id)::text) AND (full_temporary_stop_regulations1.full_temporary_stop_regulation_role = full_temporary_stop_regulations2.full_temporary_stop_regulation_role)))) AND ((full_temporary_stop_regulations1.operation)::text <> 'D'::text));


--
-- Name: full_temporary_stop_regulations_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.full_temporary_stop_regulations_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: full_temporary_stop_regulations_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.full_temporary_stop_regulations_oid_seq OWNED BY public.full_temporary_stop_regulations_oplog.oid;


--
-- Name: geographical_area_description_periods_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geographical_area_description_periods_oplog (
    geographical_area_description_period_sid integer,
    geographical_area_sid integer,
    validity_start_date timestamp without time zone,
    geographical_area_id character varying(255),
    created_at timestamp without time zone,
    validity_end_date timestamp without time zone,
    "national" boolean,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer,
    added_by_id integer,
    added_at timestamp without time zone
);


--
-- Name: geographical_area_description_periods; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.geographical_area_description_periods AS
 SELECT geographical_area_description_periods1.geographical_area_description_period_sid,
    geographical_area_description_periods1.geographical_area_sid,
    geographical_area_description_periods1.validity_start_date,
    geographical_area_description_periods1.geographical_area_id,
    geographical_area_description_periods1.validity_end_date,
    geographical_area_description_periods1."national",
    geographical_area_description_periods1.oid,
    geographical_area_description_periods1.operation,
    geographical_area_description_periods1.operation_date,
    geographical_area_description_periods1.status,
    geographical_area_description_periods1.workbasket_id,
    geographical_area_description_periods1.workbasket_sequence_number,
    geographical_area_description_periods1.added_by_id,
    geographical_area_description_periods1.added_at
   FROM public.geographical_area_description_periods_oplog geographical_area_description_periods1
  WHERE ((geographical_area_description_periods1.oid IN ( SELECT max(geographical_area_description_periods2.oid) AS max
           FROM public.geographical_area_description_periods_oplog geographical_area_description_periods2
          WHERE ((geographical_area_description_periods1.geographical_area_description_period_sid = geographical_area_description_periods2.geographical_area_description_period_sid) AND (geographical_area_description_periods1.geographical_area_sid = geographical_area_description_periods2.geographical_area_sid)))) AND ((geographical_area_description_periods1.operation)::text <> 'D'::text));


--
-- Name: geographical_area_description_periods_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.geographical_area_description_periods_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geographical_area_description_periods_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.geographical_area_description_periods_oid_seq OWNED BY public.geographical_area_description_periods_oplog.oid;


--
-- Name: geographical_area_descriptions_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geographical_area_descriptions_oplog (
    geographical_area_description_period_sid integer,
    language_id character varying(5),
    geographical_area_sid integer,
    geographical_area_id character varying(255),
    description text,
    created_at timestamp without time zone,
    "national" boolean,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer,
    added_by_id integer,
    added_at timestamp without time zone
);


--
-- Name: geographical_area_descriptions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.geographical_area_descriptions AS
 SELECT geographical_area_descriptions1.geographical_area_description_period_sid,
    geographical_area_descriptions1.language_id,
    geographical_area_descriptions1.geographical_area_sid,
    geographical_area_descriptions1.geographical_area_id,
    geographical_area_descriptions1.description,
    geographical_area_descriptions1."national",
    geographical_area_descriptions1.oid,
    geographical_area_descriptions1.operation,
    geographical_area_descriptions1.operation_date,
    geographical_area_descriptions1.status,
    geographical_area_descriptions1.workbasket_id,
    geographical_area_descriptions1.workbasket_sequence_number,
    geographical_area_descriptions1.added_by_id,
    geographical_area_descriptions1.added_at
   FROM public.geographical_area_descriptions_oplog geographical_area_descriptions1
  WHERE ((geographical_area_descriptions1.oid IN ( SELECT max(geographical_area_descriptions2.oid) AS max
           FROM public.geographical_area_descriptions_oplog geographical_area_descriptions2
          WHERE ((geographical_area_descriptions1.geographical_area_description_period_sid = geographical_area_descriptions2.geographical_area_description_period_sid) AND (geographical_area_descriptions1.geographical_area_sid = geographical_area_descriptions2.geographical_area_sid)))) AND ((geographical_area_descriptions1.operation)::text <> 'D'::text));


--
-- Name: geographical_area_descriptions_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.geographical_area_descriptions_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geographical_area_descriptions_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.geographical_area_descriptions_oid_seq OWNED BY public.geographical_area_descriptions_oplog.oid;


--
-- Name: geographical_area_memberships_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geographical_area_memberships_oplog (
    geographical_area_sid integer,
    geographical_area_group_sid integer,
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    created_at timestamp without time zone,
    "national" boolean,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer,
    added_by_id integer,
    added_at timestamp without time zone
);


--
-- Name: geographical_area_memberships; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.geographical_area_memberships AS
 SELECT geographical_area_memberships1.geographical_area_sid,
    geographical_area_memberships1.geographical_area_group_sid,
    geographical_area_memberships1.validity_start_date,
    geographical_area_memberships1.validity_end_date,
    geographical_area_memberships1."national",
    geographical_area_memberships1.oid,
    geographical_area_memberships1.operation,
    geographical_area_memberships1.operation_date,
    geographical_area_memberships1.status,
    geographical_area_memberships1.workbasket_id,
    geographical_area_memberships1.workbasket_sequence_number,
    geographical_area_memberships1.added_by_id,
    geographical_area_memberships1.added_at
   FROM public.geographical_area_memberships_oplog geographical_area_memberships1
  WHERE ((geographical_area_memberships1.oid IN ( SELECT max(geographical_area_memberships2.oid) AS max
           FROM public.geographical_area_memberships_oplog geographical_area_memberships2
          WHERE ((geographical_area_memberships1.geographical_area_sid = geographical_area_memberships2.geographical_area_sid) AND (geographical_area_memberships1.geographical_area_group_sid = geographical_area_memberships2.geographical_area_group_sid) AND (geographical_area_memberships1.validity_start_date = geographical_area_memberships2.validity_start_date)))) AND ((geographical_area_memberships1.operation)::text <> 'D'::text));


--
-- Name: geographical_area_memberships_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.geographical_area_memberships_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geographical_area_memberships_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.geographical_area_memberships_oid_seq OWNED BY public.geographical_area_memberships_oplog.oid;


--
-- Name: geographical_areas_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geographical_areas_oplog (
    geographical_area_sid integer,
    parent_geographical_area_group_sid integer,
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    geographical_code character varying(255),
    geographical_area_id character varying(255),
    created_at timestamp without time zone,
    "national" boolean,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer,
    added_by_id integer,
    added_at timestamp without time zone
);


--
-- Name: geographical_areas; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.geographical_areas AS
 SELECT geographical_areas1.geographical_area_sid,
    geographical_areas1.parent_geographical_area_group_sid,
    geographical_areas1.validity_start_date,
    geographical_areas1.validity_end_date,
    geographical_areas1.geographical_code,
    geographical_areas1.geographical_area_id,
    geographical_areas1."national",
    geographical_areas1.oid,
    geographical_areas1.operation,
    geographical_areas1.operation_date,
    geographical_areas1.status,
    geographical_areas1.workbasket_id,
    geographical_areas1.workbasket_sequence_number,
    geographical_areas1.added_by_id,
    geographical_areas1.added_at
   FROM public.geographical_areas_oplog geographical_areas1
  WHERE ((geographical_areas1.oid IN ( SELECT max(geographical_areas2.oid) AS max
           FROM public.geographical_areas_oplog geographical_areas2
          WHERE (geographical_areas1.geographical_area_sid = geographical_areas2.geographical_area_sid))) AND ((geographical_areas1.operation)::text <> 'D'::text));


--
-- Name: geographical_areas_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.geographical_areas_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geographical_areas_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.geographical_areas_oid_seq OWNED BY public.geographical_areas_oplog.oid;


--
-- Name: goods_nomenclature_description_periods_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.goods_nomenclature_description_periods_oplog (
    goods_nomenclature_description_period_sid integer,
    goods_nomenclature_sid integer,
    validity_start_date timestamp without time zone,
    goods_nomenclature_item_id character varying(10),
    productline_suffix character varying(2),
    created_at timestamp without time zone,
    validity_end_date timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer,
    added_by_id integer,
    added_at timestamp without time zone,
    "national" boolean
);


--
-- Name: goods_nomenclature_description_periods; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.goods_nomenclature_description_periods AS
 SELECT goods_nomenclature_description_periods1.goods_nomenclature_description_period_sid,
    goods_nomenclature_description_periods1.goods_nomenclature_sid,
    goods_nomenclature_description_periods1.validity_start_date,
    goods_nomenclature_description_periods1.goods_nomenclature_item_id,
    goods_nomenclature_description_periods1.productline_suffix,
    goods_nomenclature_description_periods1.validity_end_date,
    goods_nomenclature_description_periods1.oid,
    goods_nomenclature_description_periods1.operation,
    goods_nomenclature_description_periods1.operation_date,
    goods_nomenclature_description_periods1.status,
    goods_nomenclature_description_periods1.workbasket_id,
    goods_nomenclature_description_periods1.workbasket_sequence_number,
    goods_nomenclature_description_periods1.added_by_id,
    goods_nomenclature_description_periods1.added_at,
    goods_nomenclature_description_periods1."national"
   FROM public.goods_nomenclature_description_periods_oplog goods_nomenclature_description_periods1
  WHERE ((goods_nomenclature_description_periods1.oid IN ( SELECT max(goods_nomenclature_description_periods2.oid) AS max
           FROM public.goods_nomenclature_description_periods_oplog goods_nomenclature_description_periods2
          WHERE (goods_nomenclature_description_periods1.goods_nomenclature_description_period_sid = goods_nomenclature_description_periods2.goods_nomenclature_description_period_sid))) AND ((goods_nomenclature_description_periods1.operation)::text <> 'D'::text));


--
-- Name: goods_nomenclature_description_periods_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.goods_nomenclature_description_periods_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: goods_nomenclature_description_periods_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.goods_nomenclature_description_periods_oid_seq OWNED BY public.goods_nomenclature_description_periods_oplog.oid;


--
-- Name: goods_nomenclature_descriptions_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.goods_nomenclature_descriptions_oplog (
    goods_nomenclature_description_period_sid integer,
    language_id character varying(5),
    goods_nomenclature_sid integer,
    goods_nomenclature_item_id character varying(10),
    productline_suffix character varying(2),
    description text,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer,
    added_by_id integer,
    added_at timestamp without time zone,
    "national" boolean
);


--
-- Name: goods_nomenclature_descriptions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.goods_nomenclature_descriptions AS
 SELECT goods_nomenclature_descriptions1.goods_nomenclature_description_period_sid,
    goods_nomenclature_descriptions1.language_id,
    goods_nomenclature_descriptions1.goods_nomenclature_sid,
    goods_nomenclature_descriptions1.goods_nomenclature_item_id,
    goods_nomenclature_descriptions1.productline_suffix,
    goods_nomenclature_descriptions1.description,
    goods_nomenclature_descriptions1.oid,
    goods_nomenclature_descriptions1.operation,
    goods_nomenclature_descriptions1.operation_date,
    goods_nomenclature_descriptions1.status,
    goods_nomenclature_descriptions1.workbasket_id,
    goods_nomenclature_descriptions1.workbasket_sequence_number,
    goods_nomenclature_descriptions1.added_by_id,
    goods_nomenclature_descriptions1.added_at,
    goods_nomenclature_descriptions1."national"
   FROM public.goods_nomenclature_descriptions_oplog goods_nomenclature_descriptions1
  WHERE ((goods_nomenclature_descriptions1.oid IN ( SELECT max(goods_nomenclature_descriptions2.oid) AS max
           FROM public.goods_nomenclature_descriptions_oplog goods_nomenclature_descriptions2
          WHERE ((goods_nomenclature_descriptions1.goods_nomenclature_sid = goods_nomenclature_descriptions2.goods_nomenclature_sid) AND (goods_nomenclature_descriptions1.goods_nomenclature_description_period_sid = goods_nomenclature_descriptions2.goods_nomenclature_description_period_sid)))) AND ((goods_nomenclature_descriptions1.operation)::text <> 'D'::text));


--
-- Name: goods_nomenclature_descriptions_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.goods_nomenclature_descriptions_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: goods_nomenclature_descriptions_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.goods_nomenclature_descriptions_oid_seq OWNED BY public.goods_nomenclature_descriptions_oplog.oid;


--
-- Name: goods_nomenclature_group_descriptions_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.goods_nomenclature_group_descriptions_oplog (
    goods_nomenclature_group_type character varying(1),
    goods_nomenclature_group_id character varying(6),
    language_id character varying(5),
    description text,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: goods_nomenclature_group_descriptions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.goods_nomenclature_group_descriptions AS
 SELECT goods_nomenclature_group_descriptions1.goods_nomenclature_group_type,
    goods_nomenclature_group_descriptions1.goods_nomenclature_group_id,
    goods_nomenclature_group_descriptions1.language_id,
    goods_nomenclature_group_descriptions1.description,
    goods_nomenclature_group_descriptions1.oid,
    goods_nomenclature_group_descriptions1.operation,
    goods_nomenclature_group_descriptions1.operation_date,
    goods_nomenclature_group_descriptions1.status,
    goods_nomenclature_group_descriptions1.workbasket_id,
    goods_nomenclature_group_descriptions1.workbasket_sequence_number
   FROM public.goods_nomenclature_group_descriptions_oplog goods_nomenclature_group_descriptions1
  WHERE ((goods_nomenclature_group_descriptions1.oid IN ( SELECT max(goods_nomenclature_group_descriptions2.oid) AS max
           FROM public.goods_nomenclature_group_descriptions_oplog goods_nomenclature_group_descriptions2
          WHERE (((goods_nomenclature_group_descriptions1.goods_nomenclature_group_id)::text = (goods_nomenclature_group_descriptions2.goods_nomenclature_group_id)::text) AND ((goods_nomenclature_group_descriptions1.goods_nomenclature_group_type)::text = (goods_nomenclature_group_descriptions2.goods_nomenclature_group_type)::text)))) AND ((goods_nomenclature_group_descriptions1.operation)::text <> 'D'::text));


--
-- Name: goods_nomenclature_group_descriptions_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.goods_nomenclature_group_descriptions_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: goods_nomenclature_group_descriptions_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.goods_nomenclature_group_descriptions_oid_seq OWNED BY public.goods_nomenclature_group_descriptions_oplog.oid;


--
-- Name: goods_nomenclature_groups_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.goods_nomenclature_groups_oplog (
    goods_nomenclature_group_type character varying(1),
    goods_nomenclature_group_id character varying(6),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    nomenclature_group_facility_code integer,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: goods_nomenclature_groups; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.goods_nomenclature_groups AS
 SELECT goods_nomenclature_groups1.goods_nomenclature_group_type,
    goods_nomenclature_groups1.goods_nomenclature_group_id,
    goods_nomenclature_groups1.validity_start_date,
    goods_nomenclature_groups1.validity_end_date,
    goods_nomenclature_groups1.nomenclature_group_facility_code,
    goods_nomenclature_groups1.oid,
    goods_nomenclature_groups1.operation,
    goods_nomenclature_groups1.operation_date,
    goods_nomenclature_groups1.status,
    goods_nomenclature_groups1.workbasket_id,
    goods_nomenclature_groups1.workbasket_sequence_number
   FROM public.goods_nomenclature_groups_oplog goods_nomenclature_groups1
  WHERE ((goods_nomenclature_groups1.oid IN ( SELECT max(goods_nomenclature_groups2.oid) AS max
           FROM public.goods_nomenclature_groups_oplog goods_nomenclature_groups2
          WHERE (((goods_nomenclature_groups1.goods_nomenclature_group_id)::text = (goods_nomenclature_groups2.goods_nomenclature_group_id)::text) AND ((goods_nomenclature_groups1.goods_nomenclature_group_type)::text = (goods_nomenclature_groups2.goods_nomenclature_group_type)::text)))) AND ((goods_nomenclature_groups1.operation)::text <> 'D'::text));


--
-- Name: goods_nomenclature_groups_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.goods_nomenclature_groups_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: goods_nomenclature_groups_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.goods_nomenclature_groups_oid_seq OWNED BY public.goods_nomenclature_groups_oplog.oid;


--
-- Name: goods_nomenclature_indents_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.goods_nomenclature_indents_oplog (
    goods_nomenclature_indent_sid integer,
    goods_nomenclature_sid integer,
    validity_start_date timestamp without time zone,
    number_indents integer,
    goods_nomenclature_item_id character varying(10),
    productline_suffix character varying(2),
    created_at timestamp without time zone,
    validity_end_date timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer,
    added_by_id integer,
    added_at timestamp without time zone,
    "national" boolean
);


--
-- Name: goods_nomenclature_indents; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.goods_nomenclature_indents AS
 SELECT goods_nomenclature_indents1.goods_nomenclature_indent_sid,
    goods_nomenclature_indents1.goods_nomenclature_sid,
    goods_nomenclature_indents1.validity_start_date,
    goods_nomenclature_indents1.number_indents,
    goods_nomenclature_indents1.goods_nomenclature_item_id,
    goods_nomenclature_indents1.productline_suffix,
    goods_nomenclature_indents1.validity_end_date,
    goods_nomenclature_indents1.oid,
    goods_nomenclature_indents1.operation,
    goods_nomenclature_indents1.operation_date,
    goods_nomenclature_indents1.status,
    goods_nomenclature_indents1.workbasket_id,
    goods_nomenclature_indents1.workbasket_sequence_number,
    goods_nomenclature_indents1.added_by_id,
    goods_nomenclature_indents1.added_at,
    goods_nomenclature_indents1."national"
   FROM public.goods_nomenclature_indents_oplog goods_nomenclature_indents1
  WHERE ((goods_nomenclature_indents1.oid IN ( SELECT max(goods_nomenclature_indents2.oid) AS max
           FROM public.goods_nomenclature_indents_oplog goods_nomenclature_indents2
          WHERE (goods_nomenclature_indents1.goods_nomenclature_indent_sid = goods_nomenclature_indents2.goods_nomenclature_indent_sid))) AND ((goods_nomenclature_indents1.operation)::text <> 'D'::text));


--
-- Name: goods_nomenclature_indents_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.goods_nomenclature_indents_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: goods_nomenclature_indents_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.goods_nomenclature_indents_oid_seq OWNED BY public.goods_nomenclature_indents_oplog.oid;


--
-- Name: goods_nomenclature_origins_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.goods_nomenclature_origins_oplog (
    goods_nomenclature_sid integer,
    derived_goods_nomenclature_item_id character varying(10),
    derived_productline_suffix character varying(2),
    goods_nomenclature_item_id character varying(10),
    productline_suffix character varying(2),
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer,
    added_by_id integer,
    added_at timestamp without time zone,
    "national" boolean
);


--
-- Name: goods_nomenclature_origins; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.goods_nomenclature_origins AS
 SELECT goods_nomenclature_origins1.goods_nomenclature_sid,
    goods_nomenclature_origins1.derived_goods_nomenclature_item_id,
    goods_nomenclature_origins1.derived_productline_suffix,
    goods_nomenclature_origins1.goods_nomenclature_item_id,
    goods_nomenclature_origins1.productline_suffix,
    goods_nomenclature_origins1.oid,
    goods_nomenclature_origins1.operation,
    goods_nomenclature_origins1.operation_date,
    goods_nomenclature_origins1.status,
    goods_nomenclature_origins1.workbasket_id,
    goods_nomenclature_origins1.workbasket_sequence_number,
    goods_nomenclature_origins1.added_by_id,
    goods_nomenclature_origins1.added_at,
    goods_nomenclature_origins1."national"
   FROM public.goods_nomenclature_origins_oplog goods_nomenclature_origins1
  WHERE ((goods_nomenclature_origins1.oid IN ( SELECT max(goods_nomenclature_origins2.oid) AS max
           FROM public.goods_nomenclature_origins_oplog goods_nomenclature_origins2
          WHERE ((goods_nomenclature_origins1.goods_nomenclature_sid = goods_nomenclature_origins2.goods_nomenclature_sid) AND ((goods_nomenclature_origins1.derived_goods_nomenclature_item_id)::text = (goods_nomenclature_origins2.derived_goods_nomenclature_item_id)::text) AND ((goods_nomenclature_origins1.derived_productline_suffix)::text = (goods_nomenclature_origins2.derived_productline_suffix)::text) AND ((goods_nomenclature_origins1.goods_nomenclature_item_id)::text = (goods_nomenclature_origins2.goods_nomenclature_item_id)::text) AND ((goods_nomenclature_origins1.productline_suffix)::text = (goods_nomenclature_origins2.productline_suffix)::text)))) AND ((goods_nomenclature_origins1.operation)::text <> 'D'::text));


--
-- Name: goods_nomenclature_origins_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.goods_nomenclature_origins_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: goods_nomenclature_origins_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.goods_nomenclature_origins_oid_seq OWNED BY public.goods_nomenclature_origins_oplog.oid;


--
-- Name: goods_nomenclature_successors_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.goods_nomenclature_successors_oplog (
    goods_nomenclature_sid integer,
    absorbed_goods_nomenclature_item_id character varying(10),
    absorbed_productline_suffix character varying(2),
    goods_nomenclature_item_id character varying(10),
    productline_suffix character varying(2),
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: goods_nomenclature_successors; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.goods_nomenclature_successors AS
 SELECT goods_nomenclature_successors1.goods_nomenclature_sid,
    goods_nomenclature_successors1.absorbed_goods_nomenclature_item_id,
    goods_nomenclature_successors1.absorbed_productline_suffix,
    goods_nomenclature_successors1.goods_nomenclature_item_id,
    goods_nomenclature_successors1.productline_suffix,
    goods_nomenclature_successors1.oid,
    goods_nomenclature_successors1.operation,
    goods_nomenclature_successors1.operation_date,
    goods_nomenclature_successors1.status,
    goods_nomenclature_successors1.workbasket_id,
    goods_nomenclature_successors1.workbasket_sequence_number
   FROM public.goods_nomenclature_successors_oplog goods_nomenclature_successors1
  WHERE ((goods_nomenclature_successors1.oid IN ( SELECT max(goods_nomenclature_successors2.oid) AS max
           FROM public.goods_nomenclature_successors_oplog goods_nomenclature_successors2
          WHERE ((goods_nomenclature_successors1.goods_nomenclature_sid = goods_nomenclature_successors2.goods_nomenclature_sid) AND ((goods_nomenclature_successors1.absorbed_goods_nomenclature_item_id)::text = (goods_nomenclature_successors2.absorbed_goods_nomenclature_item_id)::text) AND ((goods_nomenclature_successors1.absorbed_productline_suffix)::text = (goods_nomenclature_successors2.absorbed_productline_suffix)::text) AND ((goods_nomenclature_successors1.goods_nomenclature_item_id)::text = (goods_nomenclature_successors2.goods_nomenclature_item_id)::text) AND ((goods_nomenclature_successors1.productline_suffix)::text = (goods_nomenclature_successors2.productline_suffix)::text)))) AND ((goods_nomenclature_successors1.operation)::text <> 'D'::text));


--
-- Name: goods_nomenclature_successors_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.goods_nomenclature_successors_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: goods_nomenclature_successors_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.goods_nomenclature_successors_oid_seq OWNED BY public.goods_nomenclature_successors_oplog.oid;


--
-- Name: goods_nomenclatures_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.goods_nomenclatures_oplog (
    goods_nomenclature_sid integer,
    goods_nomenclature_item_id character varying(10),
    producline_suffix character varying(255),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    statistical_indicator integer,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer,
    added_by_id integer,
    added_at timestamp without time zone,
    "national" boolean
);


--
-- Name: goods_nomenclatures; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.goods_nomenclatures AS
 SELECT goods_nomenclatures1.goods_nomenclature_sid,
    goods_nomenclatures1.goods_nomenclature_item_id,
    goods_nomenclatures1.producline_suffix,
    goods_nomenclatures1.validity_start_date,
    goods_nomenclatures1.validity_end_date,
    goods_nomenclatures1.statistical_indicator,
    goods_nomenclatures1.oid,
    goods_nomenclatures1.operation,
    goods_nomenclatures1.operation_date,
    goods_nomenclatures1.status,
    goods_nomenclatures1.workbasket_id,
    goods_nomenclatures1.workbasket_sequence_number,
    goods_nomenclatures1.added_by_id,
    goods_nomenclatures1.added_at,
    goods_nomenclatures1."national"
   FROM public.goods_nomenclatures_oplog goods_nomenclatures1
  WHERE ((goods_nomenclatures1.oid IN ( SELECT max(goods_nomenclatures2.oid) AS max
           FROM public.goods_nomenclatures_oplog goods_nomenclatures2
          WHERE (goods_nomenclatures1.goods_nomenclature_sid = goods_nomenclatures2.goods_nomenclature_sid))) AND ((goods_nomenclatures1.operation)::text <> 'D'::text));


--
-- Name: goods_nomenclatures_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.goods_nomenclatures_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: goods_nomenclatures_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.goods_nomenclatures_oid_seq OWNED BY public.goods_nomenclatures_oplog.oid;


--
-- Name: hidden_goods_nomenclatures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hidden_goods_nomenclatures (
    goods_nomenclature_item_id text,
    created_at timestamp without time zone
);


--
-- Name: language_descriptions_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.language_descriptions_oplog (
    language_code_id character varying(255),
    language_id character varying(5),
    description text,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: language_descriptions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.language_descriptions AS
 SELECT language_descriptions1.language_code_id,
    language_descriptions1.language_id,
    language_descriptions1.description,
    language_descriptions1.oid,
    language_descriptions1.operation,
    language_descriptions1.operation_date,
    language_descriptions1.status,
    language_descriptions1.workbasket_id,
    language_descriptions1.workbasket_sequence_number
   FROM public.language_descriptions_oplog language_descriptions1
  WHERE ((language_descriptions1.oid IN ( SELECT max(language_descriptions2.oid) AS max
           FROM public.language_descriptions_oplog language_descriptions2
          WHERE (((language_descriptions1.language_id)::text = (language_descriptions2.language_id)::text) AND ((language_descriptions1.language_code_id)::text = (language_descriptions2.language_code_id)::text)))) AND ((language_descriptions1.operation)::text <> 'D'::text));


--
-- Name: language_descriptions_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.language_descriptions_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: language_descriptions_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.language_descriptions_oid_seq OWNED BY public.language_descriptions_oplog.oid;


--
-- Name: languages_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.languages_oplog (
    language_id character varying(5),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: languages; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.languages AS
 SELECT languages1.language_id,
    languages1.validity_start_date,
    languages1.validity_end_date,
    languages1.oid,
    languages1.operation,
    languages1.operation_date,
    languages1.status,
    languages1.workbasket_id,
    languages1.workbasket_sequence_number
   FROM public.languages_oplog languages1
  WHERE ((languages1.oid IN ( SELECT max(languages2.oid) AS max
           FROM public.languages_oplog languages2
          WHERE ((languages1.language_id)::text = (languages2.language_id)::text))) AND ((languages1.operation)::text <> 'D'::text));


--
-- Name: languages_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.languages_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: languages_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.languages_oid_seq OWNED BY public.languages_oplog.oid;


--
-- Name: measure_action_descriptions_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.measure_action_descriptions_oplog (
    action_code character varying(255),
    language_id character varying(5),
    description text,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: measure_action_descriptions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.measure_action_descriptions AS
 SELECT measure_action_descriptions1.action_code,
    measure_action_descriptions1.language_id,
    measure_action_descriptions1.description,
    measure_action_descriptions1.oid,
    measure_action_descriptions1.operation,
    measure_action_descriptions1.operation_date,
    measure_action_descriptions1.status,
    measure_action_descriptions1.workbasket_id,
    measure_action_descriptions1.workbasket_sequence_number
   FROM public.measure_action_descriptions_oplog measure_action_descriptions1
  WHERE ((measure_action_descriptions1.oid IN ( SELECT max(measure_action_descriptions2.oid) AS max
           FROM public.measure_action_descriptions_oplog measure_action_descriptions2
          WHERE ((measure_action_descriptions1.action_code)::text = (measure_action_descriptions2.action_code)::text))) AND ((measure_action_descriptions1.operation)::text <> 'D'::text));


--
-- Name: measure_action_descriptions_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.measure_action_descriptions_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: measure_action_descriptions_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.measure_action_descriptions_oid_seq OWNED BY public.measure_action_descriptions_oplog.oid;


--
-- Name: measure_actions_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.measure_actions_oplog (
    action_code character varying(255),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: measure_actions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.measure_actions AS
 SELECT measure_actions1.action_code,
    measure_actions1.validity_start_date,
    measure_actions1.validity_end_date,
    measure_actions1.oid,
    measure_actions1.operation,
    measure_actions1.operation_date,
    measure_actions1.status,
    measure_actions1.workbasket_id,
    measure_actions1.workbasket_sequence_number
   FROM public.measure_actions_oplog measure_actions1
  WHERE ((measure_actions1.oid IN ( SELECT max(measure_actions2.oid) AS max
           FROM public.measure_actions_oplog measure_actions2
          WHERE ((measure_actions1.action_code)::text = (measure_actions2.action_code)::text))) AND ((measure_actions1.operation)::text <> 'D'::text));


--
-- Name: measure_actions_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.measure_actions_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: measure_actions_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.measure_actions_oid_seq OWNED BY public.measure_actions_oplog.oid;


--
-- Name: measure_components_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.measure_components_oplog (
    measure_sid integer,
    duty_expression_id character varying(255),
    duty_amount double precision,
    monetary_unit_code character varying(255),
    measurement_unit_code character varying(3),
    measurement_unit_qualifier_code character varying(1),
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    added_by_id integer,
    added_at timestamp without time zone,
    "national" boolean,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer,
    original_duty_expression_id text
);


--
-- Name: measure_components; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.measure_components AS
 SELECT measure_components1.measure_sid,
    measure_components1.duty_expression_id,
    measure_components1.duty_amount,
    measure_components1.monetary_unit_code,
    measure_components1.measurement_unit_code,
    measure_components1.measurement_unit_qualifier_code,
    measure_components1.oid,
    measure_components1.operation,
    measure_components1.operation_date,
    measure_components1.added_by_id,
    measure_components1.added_at,
    measure_components1."national",
    measure_components1.status,
    measure_components1.workbasket_id,
    measure_components1.workbasket_sequence_number,
    measure_components1.original_duty_expression_id
   FROM public.measure_components_oplog measure_components1
  WHERE ((measure_components1.oid IN ( SELECT max(measure_components2.oid) AS max
           FROM public.measure_components_oplog measure_components2
          WHERE ((measure_components1.measure_sid = measure_components2.measure_sid) AND ((measure_components1.duty_expression_id)::text = (measure_components2.duty_expression_id)::text)))) AND ((measure_components1.operation)::text <> 'D'::text));


--
-- Name: measure_components_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.measure_components_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: measure_components_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.measure_components_oid_seq OWNED BY public.measure_components_oplog.oid;


--
-- Name: measure_condition_code_descriptions_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.measure_condition_code_descriptions_oplog (
    condition_code character varying(255),
    language_id character varying(5),
    description text,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: measure_condition_code_descriptions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.measure_condition_code_descriptions AS
 SELECT measure_condition_code_descriptions1.condition_code,
    measure_condition_code_descriptions1.language_id,
    measure_condition_code_descriptions1.description,
    measure_condition_code_descriptions1.oid,
    measure_condition_code_descriptions1.operation,
    measure_condition_code_descriptions1.operation_date,
    measure_condition_code_descriptions1.status,
    measure_condition_code_descriptions1.workbasket_id,
    measure_condition_code_descriptions1.workbasket_sequence_number
   FROM public.measure_condition_code_descriptions_oplog measure_condition_code_descriptions1
  WHERE ((measure_condition_code_descriptions1.oid IN ( SELECT max(measure_condition_code_descriptions2.oid) AS max
           FROM public.measure_condition_code_descriptions_oplog measure_condition_code_descriptions2
          WHERE ((measure_condition_code_descriptions1.condition_code)::text = (measure_condition_code_descriptions2.condition_code)::text))) AND ((measure_condition_code_descriptions1.operation)::text <> 'D'::text));


--
-- Name: measure_condition_code_descriptions_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.measure_condition_code_descriptions_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: measure_condition_code_descriptions_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.measure_condition_code_descriptions_oid_seq OWNED BY public.measure_condition_code_descriptions_oplog.oid;


--
-- Name: measure_condition_codes_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.measure_condition_codes_oplog (
    condition_code character varying(255),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: measure_condition_codes; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.measure_condition_codes AS
 SELECT measure_condition_codes1.condition_code,
    measure_condition_codes1.validity_start_date,
    measure_condition_codes1.validity_end_date,
    measure_condition_codes1.oid,
    measure_condition_codes1.operation,
    measure_condition_codes1.operation_date,
    measure_condition_codes1.status,
    measure_condition_codes1.workbasket_id,
    measure_condition_codes1.workbasket_sequence_number
   FROM public.measure_condition_codes_oplog measure_condition_codes1
  WHERE ((measure_condition_codes1.oid IN ( SELECT max(measure_condition_codes2.oid) AS max
           FROM public.measure_condition_codes_oplog measure_condition_codes2
          WHERE ((measure_condition_codes1.condition_code)::text = (measure_condition_codes2.condition_code)::text))) AND ((measure_condition_codes1.operation)::text <> 'D'::text));


--
-- Name: measure_condition_codes_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.measure_condition_codes_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: measure_condition_codes_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.measure_condition_codes_oid_seq OWNED BY public.measure_condition_codes_oplog.oid;


--
-- Name: measure_condition_components_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.measure_condition_components_oplog (
    measure_condition_sid integer,
    duty_expression_id character varying(255),
    duty_amount double precision,
    monetary_unit_code character varying(255),
    measurement_unit_code character varying(3),
    measurement_unit_qualifier_code character varying(1),
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    added_by_id integer,
    added_at timestamp without time zone,
    "national" boolean,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer,
    original_duty_expression_id text
);


--
-- Name: measure_condition_components; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.measure_condition_components AS
 SELECT measure_condition_components1.measure_condition_sid,
    measure_condition_components1.duty_expression_id,
    measure_condition_components1.duty_amount,
    measure_condition_components1.monetary_unit_code,
    measure_condition_components1.measurement_unit_code,
    measure_condition_components1.measurement_unit_qualifier_code,
    measure_condition_components1.oid,
    measure_condition_components1.operation,
    measure_condition_components1.operation_date,
    measure_condition_components1.added_by_id,
    measure_condition_components1.added_at,
    measure_condition_components1."national",
    measure_condition_components1.status,
    measure_condition_components1.workbasket_id,
    measure_condition_components1.workbasket_sequence_number,
    measure_condition_components1.original_duty_expression_id
   FROM public.measure_condition_components_oplog measure_condition_components1
  WHERE ((measure_condition_components1.oid IN ( SELECT max(measure_condition_components2.oid) AS max
           FROM public.measure_condition_components_oplog measure_condition_components2
          WHERE ((measure_condition_components1.measure_condition_sid = measure_condition_components2.measure_condition_sid) AND ((measure_condition_components1.duty_expression_id)::text = (measure_condition_components2.duty_expression_id)::text)))) AND ((measure_condition_components1.operation)::text <> 'D'::text));


--
-- Name: measure_condition_components_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.measure_condition_components_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: measure_condition_components_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.measure_condition_components_oid_seq OWNED BY public.measure_condition_components_oplog.oid;


--
-- Name: measure_conditions_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.measure_conditions_oplog (
    measure_condition_sid integer,
    measure_sid integer,
    condition_code character varying(255),
    component_sequence_number integer,
    condition_duty_amount double precision,
    condition_monetary_unit_code character varying(255),
    condition_measurement_unit_code character varying(3),
    condition_measurement_unit_qualifier_code character varying(1),
    action_code character varying(255),
    certificate_type_code character varying(1),
    certificate_code character varying(3),
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    added_by_id integer,
    added_at timestamp without time zone,
    "national" boolean,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer,
    original_measure_condition_code text
);


--
-- Name: measure_conditions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.measure_conditions AS
 SELECT measure_conditions1.measure_condition_sid,
    measure_conditions1.measure_sid,
    measure_conditions1.condition_code,
    measure_conditions1.component_sequence_number,
    measure_conditions1.condition_duty_amount,
    measure_conditions1.condition_monetary_unit_code,
    measure_conditions1.condition_measurement_unit_code,
    measure_conditions1.condition_measurement_unit_qualifier_code,
    measure_conditions1.action_code,
    measure_conditions1.certificate_type_code,
    measure_conditions1.certificate_code,
    measure_conditions1.oid,
    measure_conditions1.operation,
    measure_conditions1.operation_date,
    measure_conditions1.added_by_id,
    measure_conditions1.added_at,
    measure_conditions1."national",
    measure_conditions1.status,
    measure_conditions1.workbasket_id,
    measure_conditions1.workbasket_sequence_number,
    measure_conditions1.original_measure_condition_code
   FROM public.measure_conditions_oplog measure_conditions1
  WHERE ((measure_conditions1.oid IN ( SELECT max(measure_conditions2.oid) AS max
           FROM public.measure_conditions_oplog measure_conditions2
          WHERE (measure_conditions1.measure_condition_sid = measure_conditions2.measure_condition_sid))) AND ((measure_conditions1.operation)::text <> 'D'::text));


--
-- Name: measure_conditions_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.measure_conditions_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: measure_conditions_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.measure_conditions_oid_seq OWNED BY public.measure_conditions_oplog.oid;


--
-- Name: measure_excluded_geographical_areas_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.measure_excluded_geographical_areas_oplog (
    measure_sid integer,
    excluded_geographical_area character varying(255),
    geographical_area_sid integer,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    added_by_id integer,
    added_at timestamp without time zone,
    "national" boolean,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: measure_excluded_geographical_areas; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.measure_excluded_geographical_areas AS
 SELECT measure_excluded_geographical_areas1.measure_sid,
    measure_excluded_geographical_areas1.excluded_geographical_area,
    measure_excluded_geographical_areas1.geographical_area_sid,
    measure_excluded_geographical_areas1.oid,
    measure_excluded_geographical_areas1.operation,
    measure_excluded_geographical_areas1.operation_date,
    measure_excluded_geographical_areas1.added_by_id,
    measure_excluded_geographical_areas1.added_at,
    measure_excluded_geographical_areas1."national",
    measure_excluded_geographical_areas1.status,
    measure_excluded_geographical_areas1.workbasket_id,
    measure_excluded_geographical_areas1.workbasket_sequence_number
   FROM public.measure_excluded_geographical_areas_oplog measure_excluded_geographical_areas1
  WHERE ((measure_excluded_geographical_areas1.oid IN ( SELECT max(measure_excluded_geographical_areas2.oid) AS max
           FROM public.measure_excluded_geographical_areas_oplog measure_excluded_geographical_areas2
          WHERE ((measure_excluded_geographical_areas1.measure_sid = measure_excluded_geographical_areas2.measure_sid) AND (measure_excluded_geographical_areas1.geographical_area_sid = measure_excluded_geographical_areas2.geographical_area_sid)))) AND ((measure_excluded_geographical_areas1.operation)::text <> 'D'::text));


--
-- Name: measure_excluded_geographical_areas_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.measure_excluded_geographical_areas_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: measure_excluded_geographical_areas_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.measure_excluded_geographical_areas_oid_seq OWNED BY public.measure_excluded_geographical_areas_oplog.oid;


--
-- Name: measure_partial_temporary_stops_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.measure_partial_temporary_stops_oplog (
    measure_sid integer,
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    partial_temporary_stop_regulation_id character varying(255),
    partial_temporary_stop_regulation_officialjournal_number character varying(255),
    partial_temporary_stop_regulation_officialjournal_page integer,
    abrogation_regulation_id character varying(255),
    abrogation_regulation_officialjournal_number character varying(255),
    abrogation_regulation_officialjournal_page integer,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: measure_partial_temporary_stops; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.measure_partial_temporary_stops AS
 SELECT measure_partial_temporary_stops1.measure_sid,
    measure_partial_temporary_stops1.validity_start_date,
    measure_partial_temporary_stops1.validity_end_date,
    measure_partial_temporary_stops1.partial_temporary_stop_regulation_id,
    measure_partial_temporary_stops1.partial_temporary_stop_regulation_officialjournal_number,
    measure_partial_temporary_stops1.partial_temporary_stop_regulation_officialjournal_page,
    measure_partial_temporary_stops1.abrogation_regulation_id,
    measure_partial_temporary_stops1.abrogation_regulation_officialjournal_number,
    measure_partial_temporary_stops1.abrogation_regulation_officialjournal_page,
    measure_partial_temporary_stops1.oid,
    measure_partial_temporary_stops1.operation,
    measure_partial_temporary_stops1.operation_date,
    measure_partial_temporary_stops1.status,
    measure_partial_temporary_stops1.workbasket_id,
    measure_partial_temporary_stops1.workbasket_sequence_number
   FROM public.measure_partial_temporary_stops_oplog measure_partial_temporary_stops1
  WHERE ((measure_partial_temporary_stops1.oid IN ( SELECT max(measure_partial_temporary_stops2.oid) AS max
           FROM public.measure_partial_temporary_stops_oplog measure_partial_temporary_stops2
          WHERE ((measure_partial_temporary_stops1.measure_sid = measure_partial_temporary_stops2.measure_sid) AND ((measure_partial_temporary_stops1.partial_temporary_stop_regulation_id)::text = (measure_partial_temporary_stops2.partial_temporary_stop_regulation_id)::text)))) AND ((measure_partial_temporary_stops1.operation)::text <> 'D'::text));


--
-- Name: measure_partial_temporary_stops_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.measure_partial_temporary_stops_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: measure_partial_temporary_stops_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.measure_partial_temporary_stops_oid_seq OWNED BY public.measure_partial_temporary_stops_oplog.oid;


--
-- Name: measure_type_descriptions_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.measure_type_descriptions_oplog (
    measure_type_id character varying(3),
    language_id character varying(5),
    description text,
    created_at timestamp without time zone,
    "national" boolean,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: measure_type_descriptions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.measure_type_descriptions AS
 SELECT measure_type_descriptions1.measure_type_id,
    measure_type_descriptions1.language_id,
    measure_type_descriptions1.description,
    measure_type_descriptions1."national",
    measure_type_descriptions1.oid,
    measure_type_descriptions1.operation,
    measure_type_descriptions1.operation_date,
    measure_type_descriptions1.status,
    measure_type_descriptions1.workbasket_id,
    measure_type_descriptions1.workbasket_sequence_number
   FROM public.measure_type_descriptions_oplog measure_type_descriptions1
  WHERE ((measure_type_descriptions1.oid IN ( SELECT max(measure_type_descriptions2.oid) AS max
           FROM public.measure_type_descriptions_oplog measure_type_descriptions2
          WHERE ((measure_type_descriptions1.measure_type_id)::text = (measure_type_descriptions2.measure_type_id)::text))) AND ((measure_type_descriptions1.operation)::text <> 'D'::text));


--
-- Name: measure_type_descriptions_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.measure_type_descriptions_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: measure_type_descriptions_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.measure_type_descriptions_oid_seq OWNED BY public.measure_type_descriptions_oplog.oid;


--
-- Name: measure_type_series_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.measure_type_series_oplog (
    measure_type_series_id character varying(255),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    measure_type_combination integer,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: measure_type_series; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.measure_type_series AS
 SELECT measure_type_series1.measure_type_series_id,
    measure_type_series1.validity_start_date,
    measure_type_series1.validity_end_date,
    measure_type_series1.measure_type_combination,
    measure_type_series1.oid,
    measure_type_series1.operation,
    measure_type_series1.operation_date,
    measure_type_series1.status,
    measure_type_series1.workbasket_id,
    measure_type_series1.workbasket_sequence_number
   FROM public.measure_type_series_oplog measure_type_series1
  WHERE ((measure_type_series1.oid IN ( SELECT max(measure_type_series2.oid) AS max
           FROM public.measure_type_series_oplog measure_type_series2
          WHERE ((measure_type_series1.measure_type_series_id)::text = (measure_type_series2.measure_type_series_id)::text))) AND ((measure_type_series1.operation)::text <> 'D'::text));


--
-- Name: measure_type_series_descriptions_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.measure_type_series_descriptions_oplog (
    measure_type_series_id character varying(255),
    language_id character varying(5),
    description text,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: measure_type_series_descriptions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.measure_type_series_descriptions AS
 SELECT measure_type_series_descriptions1.measure_type_series_id,
    measure_type_series_descriptions1.language_id,
    measure_type_series_descriptions1.description,
    measure_type_series_descriptions1.oid,
    measure_type_series_descriptions1.operation,
    measure_type_series_descriptions1.operation_date,
    measure_type_series_descriptions1.status,
    measure_type_series_descriptions1.workbasket_id,
    measure_type_series_descriptions1.workbasket_sequence_number
   FROM public.measure_type_series_descriptions_oplog measure_type_series_descriptions1
  WHERE ((measure_type_series_descriptions1.oid IN ( SELECT max(measure_type_series_descriptions2.oid) AS max
           FROM public.measure_type_series_descriptions_oplog measure_type_series_descriptions2
          WHERE ((measure_type_series_descriptions1.measure_type_series_id)::text = (measure_type_series_descriptions2.measure_type_series_id)::text))) AND ((measure_type_series_descriptions1.operation)::text <> 'D'::text));


--
-- Name: measure_type_series_descriptions_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.measure_type_series_descriptions_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: measure_type_series_descriptions_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.measure_type_series_descriptions_oid_seq OWNED BY public.measure_type_series_descriptions_oplog.oid;


--
-- Name: measure_type_series_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.measure_type_series_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: measure_type_series_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.measure_type_series_oid_seq OWNED BY public.measure_type_series_oplog.oid;


--
-- Name: measure_types_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.measure_types_oplog (
    measure_type_id character varying(3),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    trade_movement_code integer,
    priority_code integer,
    measure_component_applicable_code integer,
    origin_dest_code integer,
    order_number_capture_code integer,
    measure_explosion_level integer,
    measure_type_series_id character varying(255),
    created_at timestamp without time zone,
    "national" boolean,
    measure_type_acronym character varying(3),
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: measure_types; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.measure_types AS
 SELECT measure_types1.measure_type_id,
    measure_types1.validity_start_date,
    measure_types1.validity_end_date,
    measure_types1.trade_movement_code,
    measure_types1.priority_code,
    measure_types1.measure_component_applicable_code,
    measure_types1.origin_dest_code,
    measure_types1.order_number_capture_code,
    measure_types1.measure_explosion_level,
    measure_types1.measure_type_series_id,
    measure_types1."national",
    measure_types1.measure_type_acronym,
    measure_types1.oid,
    measure_types1.operation,
    measure_types1.operation_date,
    measure_types1.status,
    measure_types1.workbasket_id,
    measure_types1.workbasket_sequence_number
   FROM public.measure_types_oplog measure_types1
  WHERE ((measure_types1.oid IN ( SELECT max(measure_types2.oid) AS max
           FROM public.measure_types_oplog measure_types2
          WHERE ((measure_types1.measure_type_id)::text = (measure_types2.measure_type_id)::text))) AND ((measure_types1.operation)::text <> 'D'::text));


--
-- Name: measure_types_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.measure_types_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: measure_types_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.measure_types_oid_seq OWNED BY public.measure_types_oplog.oid;


--
-- Name: measurement_unit_abbreviations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.measurement_unit_abbreviations (
    id integer NOT NULL,
    abbreviation text,
    measurement_unit_code text,
    measurement_unit_qualifier text
);


--
-- Name: measurement_unit_abbreviations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.measurement_unit_abbreviations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: measurement_unit_abbreviations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.measurement_unit_abbreviations_id_seq OWNED BY public.measurement_unit_abbreviations.id;


--
-- Name: measurement_unit_descriptions_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.measurement_unit_descriptions_oplog (
    measurement_unit_code character varying(3),
    language_id character varying(5),
    description text,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: measurement_unit_descriptions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.measurement_unit_descriptions AS
 SELECT measurement_unit_descriptions1.measurement_unit_code,
    measurement_unit_descriptions1.language_id,
    measurement_unit_descriptions1.description,
    measurement_unit_descriptions1.oid,
    measurement_unit_descriptions1.operation,
    measurement_unit_descriptions1.operation_date,
    measurement_unit_descriptions1.status,
    measurement_unit_descriptions1.workbasket_id,
    measurement_unit_descriptions1.workbasket_sequence_number
   FROM public.measurement_unit_descriptions_oplog measurement_unit_descriptions1
  WHERE ((measurement_unit_descriptions1.oid IN ( SELECT max(measurement_unit_descriptions2.oid) AS max
           FROM public.measurement_unit_descriptions_oplog measurement_unit_descriptions2
          WHERE ((measurement_unit_descriptions1.measurement_unit_code)::text = (measurement_unit_descriptions2.measurement_unit_code)::text))) AND ((measurement_unit_descriptions1.operation)::text <> 'D'::text));


--
-- Name: measurement_unit_descriptions_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.measurement_unit_descriptions_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: measurement_unit_descriptions_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.measurement_unit_descriptions_oid_seq OWNED BY public.measurement_unit_descriptions_oplog.oid;


--
-- Name: measurement_unit_qualifier_descriptions_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.measurement_unit_qualifier_descriptions_oplog (
    measurement_unit_qualifier_code character varying(1),
    language_id character varying(5),
    description text,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: measurement_unit_qualifier_descriptions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.measurement_unit_qualifier_descriptions AS
 SELECT measurement_unit_qualifier_descriptions1.measurement_unit_qualifier_code,
    measurement_unit_qualifier_descriptions1.language_id,
    measurement_unit_qualifier_descriptions1.description,
    measurement_unit_qualifier_descriptions1.oid,
    measurement_unit_qualifier_descriptions1.operation,
    measurement_unit_qualifier_descriptions1.operation_date,
    measurement_unit_qualifier_descriptions1.status,
    measurement_unit_qualifier_descriptions1.workbasket_id,
    measurement_unit_qualifier_descriptions1.workbasket_sequence_number
   FROM public.measurement_unit_qualifier_descriptions_oplog measurement_unit_qualifier_descriptions1
  WHERE ((measurement_unit_qualifier_descriptions1.oid IN ( SELECT max(measurement_unit_qualifier_descriptions2.oid) AS max
           FROM public.measurement_unit_qualifier_descriptions_oplog measurement_unit_qualifier_descriptions2
          WHERE ((measurement_unit_qualifier_descriptions1.measurement_unit_qualifier_code)::text = (measurement_unit_qualifier_descriptions2.measurement_unit_qualifier_code)::text))) AND ((measurement_unit_qualifier_descriptions1.operation)::text <> 'D'::text));


--
-- Name: measurement_unit_qualifier_descriptions_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.measurement_unit_qualifier_descriptions_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: measurement_unit_qualifier_descriptions_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.measurement_unit_qualifier_descriptions_oid_seq OWNED BY public.measurement_unit_qualifier_descriptions_oplog.oid;


--
-- Name: measurement_unit_qualifiers_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.measurement_unit_qualifiers_oplog (
    measurement_unit_qualifier_code character varying(1),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: measurement_unit_qualifiers; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.measurement_unit_qualifiers AS
 SELECT measurement_unit_qualifiers1.measurement_unit_qualifier_code,
    measurement_unit_qualifiers1.validity_start_date,
    measurement_unit_qualifiers1.validity_end_date,
    measurement_unit_qualifiers1.oid,
    measurement_unit_qualifiers1.operation,
    measurement_unit_qualifiers1.operation_date,
    measurement_unit_qualifiers1.status,
    measurement_unit_qualifiers1.workbasket_id,
    measurement_unit_qualifiers1.workbasket_sequence_number
   FROM public.measurement_unit_qualifiers_oplog measurement_unit_qualifiers1
  WHERE ((measurement_unit_qualifiers1.oid IN ( SELECT max(measurement_unit_qualifiers2.oid) AS max
           FROM public.measurement_unit_qualifiers_oplog measurement_unit_qualifiers2
          WHERE ((measurement_unit_qualifiers1.measurement_unit_qualifier_code)::text = (measurement_unit_qualifiers2.measurement_unit_qualifier_code)::text))) AND ((measurement_unit_qualifiers1.operation)::text <> 'D'::text));


--
-- Name: measurement_unit_qualifiers_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.measurement_unit_qualifiers_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: measurement_unit_qualifiers_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.measurement_unit_qualifiers_oid_seq OWNED BY public.measurement_unit_qualifiers_oplog.oid;


--
-- Name: measurement_units_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.measurement_units_oplog (
    measurement_unit_code character varying(3),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: measurement_units; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.measurement_units AS
 SELECT measurement_units1.measurement_unit_code,
    measurement_units1.validity_start_date,
    measurement_units1.validity_end_date,
    measurement_units1.oid,
    measurement_units1.operation,
    measurement_units1.operation_date,
    measurement_units1.status,
    measurement_units1.workbasket_id,
    measurement_units1.workbasket_sequence_number
   FROM public.measurement_units_oplog measurement_units1
  WHERE ((measurement_units1.oid IN ( SELECT max(measurement_units2.oid) AS max
           FROM public.measurement_units_oplog measurement_units2
          WHERE ((measurement_units1.measurement_unit_code)::text = (measurement_units2.measurement_unit_code)::text))) AND ((measurement_units1.operation)::text <> 'D'::text));


--
-- Name: measurement_units_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.measurement_units_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: measurement_units_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.measurement_units_oid_seq OWNED BY public.measurement_units_oplog.oid;


--
-- Name: measurements_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.measurements_oplog (
    measurement_unit_code character varying(3),
    measurement_unit_qualifier_code character varying(1),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: measurements; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.measurements AS
 SELECT measurements1.measurement_unit_code,
    measurements1.measurement_unit_qualifier_code,
    measurements1.validity_start_date,
    measurements1.validity_end_date,
    measurements1.oid,
    measurements1.operation,
    measurements1.operation_date,
    measurements1.status,
    measurements1.workbasket_id,
    measurements1.workbasket_sequence_number
   FROM public.measurements_oplog measurements1
  WHERE ((measurements1.oid IN ( SELECT max(measurements2.oid) AS max
           FROM public.measurements_oplog measurements2
          WHERE (((measurements1.measurement_unit_code)::text = (measurements2.measurement_unit_code)::text) AND ((measurements1.measurement_unit_qualifier_code)::text = (measurements2.measurement_unit_qualifier_code)::text)))) AND ((measurements1.operation)::text <> 'D'::text));


--
-- Name: measurements_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.measurements_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: measurements_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.measurements_oid_seq OWNED BY public.measurements_oplog.oid;


--
-- Name: measures_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.measures_oplog (
    measure_sid integer,
    measure_type_id character varying(3),
    geographical_area_id character varying(255),
    goods_nomenclature_item_id character varying(10),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    measure_generating_regulation_role integer,
    measure_generating_regulation_id character varying(255),
    justification_regulation_role integer,
    justification_regulation_id character varying(255),
    stopped_flag boolean,
    geographical_area_sid integer,
    goods_nomenclature_sid integer,
    ordernumber character varying(255),
    additional_code_type_id text,
    additional_code_id character varying(3),
    additional_code_sid integer,
    reduction_indicator integer,
    export_refund_nomenclature_sid integer,
    created_at timestamp without time zone,
    "national" boolean,
    tariff_measure_number character varying(10),
    invalidated_by integer,
    invalidated_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    added_by_id integer,
    added_at timestamp without time zone,
    status text,
    last_status_change_at timestamp without time zone,
    last_update_by_id integer,
    updated_at timestamp without time zone,
    workbasket_id integer,
    searchable_data jsonb DEFAULT '{}'::jsonb,
    searchable_data_updated_at timestamp without time zone,
    workbasket_sequence_number integer,
    original_measure_sid text
);


--
-- Name: measures; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.measures AS
 SELECT measures1.measure_sid,
    measures1.measure_type_id,
    measures1.geographical_area_id,
    measures1.goods_nomenclature_item_id,
    measures1.validity_start_date,
    measures1.validity_end_date,
    measures1.measure_generating_regulation_role,
    measures1.measure_generating_regulation_id,
    measures1.justification_regulation_role,
    measures1.justification_regulation_id,
    measures1.stopped_flag,
    measures1.geographical_area_sid,
    measures1.goods_nomenclature_sid,
    measures1.ordernumber,
    measures1.additional_code_type_id,
    measures1.additional_code_id,
    measures1.additional_code_sid,
    measures1.reduction_indicator,
    measures1.export_refund_nomenclature_sid,
    measures1."national",
    measures1.tariff_measure_number,
    measures1.invalidated_by,
    measures1.invalidated_at,
    measures1.oid,
    measures1.operation,
    measures1.operation_date,
    measures1.added_by_id,
    measures1.added_at,
    measures1.status,
    measures1.last_status_change_at,
    measures1.last_update_by_id,
    measures1.workbasket_id,
    measures1.searchable_data,
    measures1.searchable_data_updated_at,
    measures1.workbasket_sequence_number,
    measures1.original_measure_sid,
    measures1.updated_at
   FROM public.measures_oplog measures1
  WHERE ((measures1.oid IN ( SELECT max(measures2.oid) AS max
           FROM public.measures_oplog measures2
          WHERE (measures1.measure_sid = measures2.measure_sid))) AND ((measures1.operation)::text <> 'D'::text));


--
-- Name: measures_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.measures_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: measures_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.measures_oid_seq OWNED BY public.measures_oplog.oid;


--
-- Name: meursing_additional_codes_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.meursing_additional_codes_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: meursing_additional_codes_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.meursing_additional_codes_oid_seq OWNED BY public.meursing_additional_codes_oplog.oid;


--
-- Name: meursing_heading_texts_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.meursing_heading_texts_oplog (
    meursing_table_plan_id character varying(2),
    meursing_heading_number integer,
    row_column_code integer,
    language_id character varying(5),
    description text,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: meursing_heading_texts; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.meursing_heading_texts AS
 SELECT meursing_heading_texts1.meursing_table_plan_id,
    meursing_heading_texts1.meursing_heading_number,
    meursing_heading_texts1.row_column_code,
    meursing_heading_texts1.language_id,
    meursing_heading_texts1.description,
    meursing_heading_texts1.oid,
    meursing_heading_texts1.operation,
    meursing_heading_texts1.operation_date,
    meursing_heading_texts1.status,
    meursing_heading_texts1.workbasket_id,
    meursing_heading_texts1.workbasket_sequence_number
   FROM public.meursing_heading_texts_oplog meursing_heading_texts1
  WHERE ((meursing_heading_texts1.oid IN ( SELECT max(meursing_heading_texts2.oid) AS max
           FROM public.meursing_heading_texts_oplog meursing_heading_texts2
          WHERE (((meursing_heading_texts1.meursing_table_plan_id)::text = (meursing_heading_texts2.meursing_table_plan_id)::text) AND (meursing_heading_texts1.meursing_heading_number = meursing_heading_texts2.meursing_heading_number) AND (meursing_heading_texts1.row_column_code = meursing_heading_texts2.row_column_code)))) AND ((meursing_heading_texts1.operation)::text <> 'D'::text));


--
-- Name: meursing_heading_texts_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.meursing_heading_texts_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: meursing_heading_texts_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.meursing_heading_texts_oid_seq OWNED BY public.meursing_heading_texts_oplog.oid;


--
-- Name: meursing_headings_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.meursing_headings_oplog (
    meursing_table_plan_id character varying(2),
    meursing_heading_number text,
    row_column_code integer,
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: meursing_headings; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.meursing_headings AS
 SELECT meursing_headings1.meursing_table_plan_id,
    meursing_headings1.meursing_heading_number,
    meursing_headings1.row_column_code,
    meursing_headings1.validity_start_date,
    meursing_headings1.validity_end_date,
    meursing_headings1.oid,
    meursing_headings1.operation,
    meursing_headings1.operation_date,
    meursing_headings1.status,
    meursing_headings1.workbasket_id,
    meursing_headings1.workbasket_sequence_number
   FROM public.meursing_headings_oplog meursing_headings1
  WHERE ((meursing_headings1.oid IN ( SELECT max(meursing_headings2.oid) AS max
           FROM public.meursing_headings_oplog meursing_headings2
          WHERE (((meursing_headings1.meursing_table_plan_id)::text = (meursing_headings2.meursing_table_plan_id)::text) AND (meursing_headings1.meursing_heading_number = meursing_headings2.meursing_heading_number) AND (meursing_headings1.row_column_code = meursing_headings2.row_column_code)))) AND ((meursing_headings1.operation)::text <> 'D'::text));


--
-- Name: meursing_headings_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.meursing_headings_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: meursing_headings_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.meursing_headings_oid_seq OWNED BY public.meursing_headings_oplog.oid;


--
-- Name: meursing_subheadings_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.meursing_subheadings_oplog (
    meursing_table_plan_id character varying(2),
    meursing_heading_number integer,
    row_column_code integer,
    subheading_sequence_number integer,
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    description text,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: meursing_subheadings; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.meursing_subheadings AS
 SELECT meursing_subheadings1.meursing_table_plan_id,
    meursing_subheadings1.meursing_heading_number,
    meursing_subheadings1.row_column_code,
    meursing_subheadings1.subheading_sequence_number,
    meursing_subheadings1.validity_start_date,
    meursing_subheadings1.validity_end_date,
    meursing_subheadings1.description,
    meursing_subheadings1.oid,
    meursing_subheadings1.operation,
    meursing_subheadings1.operation_date,
    meursing_subheadings1.status,
    meursing_subheadings1.workbasket_id,
    meursing_subheadings1.workbasket_sequence_number
   FROM public.meursing_subheadings_oplog meursing_subheadings1
  WHERE ((meursing_subheadings1.oid IN ( SELECT max(meursing_subheadings2.oid) AS max
           FROM public.meursing_subheadings_oplog meursing_subheadings2
          WHERE (((meursing_subheadings1.meursing_table_plan_id)::text = (meursing_subheadings2.meursing_table_plan_id)::text) AND (meursing_subheadings1.meursing_heading_number = meursing_subheadings2.meursing_heading_number) AND (meursing_subheadings1.row_column_code = meursing_subheadings2.row_column_code) AND (meursing_subheadings1.subheading_sequence_number = meursing_subheadings2.subheading_sequence_number)))) AND ((meursing_subheadings1.operation)::text <> 'D'::text));


--
-- Name: meursing_subheadings_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.meursing_subheadings_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: meursing_subheadings_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.meursing_subheadings_oid_seq OWNED BY public.meursing_subheadings_oplog.oid;


--
-- Name: meursing_table_cell_components_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.meursing_table_cell_components_oplog (
    meursing_additional_code_sid integer,
    meursing_table_plan_id character varying(2),
    heading_number integer,
    row_column_code integer,
    subheading_sequence_number integer,
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    additional_code character varying(3),
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: meursing_table_cell_components; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.meursing_table_cell_components AS
 SELECT meursing_table_cell_components1.meursing_additional_code_sid,
    meursing_table_cell_components1.meursing_table_plan_id,
    meursing_table_cell_components1.heading_number,
    meursing_table_cell_components1.row_column_code,
    meursing_table_cell_components1.subheading_sequence_number,
    meursing_table_cell_components1.validity_start_date,
    meursing_table_cell_components1.validity_end_date,
    meursing_table_cell_components1.additional_code,
    meursing_table_cell_components1.oid,
    meursing_table_cell_components1.operation,
    meursing_table_cell_components1.operation_date,
    meursing_table_cell_components1.status,
    meursing_table_cell_components1.workbasket_id,
    meursing_table_cell_components1.workbasket_sequence_number
   FROM public.meursing_table_cell_components_oplog meursing_table_cell_components1
  WHERE ((meursing_table_cell_components1.oid IN ( SELECT max(meursing_table_cell_components2.oid) AS max
           FROM public.meursing_table_cell_components_oplog meursing_table_cell_components2
          WHERE (((meursing_table_cell_components1.meursing_table_plan_id)::text = (meursing_table_cell_components2.meursing_table_plan_id)::text) AND (meursing_table_cell_components1.heading_number = meursing_table_cell_components2.heading_number) AND (meursing_table_cell_components1.row_column_code = meursing_table_cell_components2.row_column_code) AND (meursing_table_cell_components1.meursing_additional_code_sid = meursing_table_cell_components2.meursing_additional_code_sid)))) AND ((meursing_table_cell_components1.operation)::text <> 'D'::text));


--
-- Name: meursing_table_cell_components_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.meursing_table_cell_components_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: meursing_table_cell_components_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.meursing_table_cell_components_oid_seq OWNED BY public.meursing_table_cell_components_oplog.oid;


--
-- Name: meursing_table_plans_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.meursing_table_plans_oplog (
    meursing_table_plan_id character varying(2),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: meursing_table_plans; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.meursing_table_plans AS
 SELECT meursing_table_plans1.meursing_table_plan_id,
    meursing_table_plans1.validity_start_date,
    meursing_table_plans1.validity_end_date,
    meursing_table_plans1.oid,
    meursing_table_plans1.operation,
    meursing_table_plans1.operation_date,
    meursing_table_plans1.status,
    meursing_table_plans1.workbasket_id,
    meursing_table_plans1.workbasket_sequence_number
   FROM public.meursing_table_plans_oplog meursing_table_plans1
  WHERE ((meursing_table_plans1.oid IN ( SELECT max(meursing_table_plans2.oid) AS max
           FROM public.meursing_table_plans_oplog meursing_table_plans2
          WHERE ((meursing_table_plans1.meursing_table_plan_id)::text = (meursing_table_plans2.meursing_table_plan_id)::text))) AND ((meursing_table_plans1.operation)::text <> 'D'::text));


--
-- Name: meursing_table_plans_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.meursing_table_plans_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: meursing_table_plans_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.meursing_table_plans_oid_seq OWNED BY public.meursing_table_plans_oplog.oid;


--
-- Name: modification_regulations_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.modification_regulations_oplog (
    modification_regulation_role integer,
    modification_regulation_id character varying(255),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    published_date date,
    officialjournal_number character varying(255),
    officialjournal_page integer,
    base_regulation_role integer,
    base_regulation_id character varying(255),
    replacement_indicator integer,
    stopped_flag boolean,
    information_text text,
    approved_flag boolean,
    explicit_abrogation_regulation_role integer,
    explicit_abrogation_regulation_id character varying(8),
    effective_end_date timestamp without time zone,
    complete_abrogation_regulation_role integer,
    complete_abrogation_regulation_id character varying(8),
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    added_by_id integer,
    added_at timestamp without time zone,
    "national" boolean,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: modification_regulations; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.modification_regulations AS
 SELECT modification_regulations1.modification_regulation_role,
    modification_regulations1.modification_regulation_id,
    modification_regulations1.validity_start_date,
    modification_regulations1.validity_end_date,
    modification_regulations1.published_date,
    modification_regulations1.officialjournal_number,
    modification_regulations1.officialjournal_page,
    modification_regulations1.base_regulation_role,
    modification_regulations1.base_regulation_id,
    modification_regulations1.replacement_indicator,
    modification_regulations1.stopped_flag,
    modification_regulations1.information_text,
    modification_regulations1.approved_flag,
    modification_regulations1.explicit_abrogation_regulation_role,
    modification_regulations1.explicit_abrogation_regulation_id,
    modification_regulations1.effective_end_date,
    modification_regulations1.complete_abrogation_regulation_role,
    modification_regulations1.complete_abrogation_regulation_id,
    modification_regulations1.oid,
    modification_regulations1.operation,
    modification_regulations1.operation_date,
    modification_regulations1.added_by_id,
    modification_regulations1.added_at,
    modification_regulations1."national",
    modification_regulations1.status,
    modification_regulations1.workbasket_id,
    modification_regulations1.workbasket_sequence_number
   FROM public.modification_regulations_oplog modification_regulations1
  WHERE ((modification_regulations1.oid IN ( SELECT max(modification_regulations2.oid) AS max
           FROM public.modification_regulations_oplog modification_regulations2
          WHERE (((modification_regulations1.modification_regulation_id)::text = (modification_regulations2.modification_regulation_id)::text) AND (modification_regulations1.modification_regulation_role = modification_regulations2.modification_regulation_role)))) AND ((modification_regulations1.operation)::text <> 'D'::text));


--
-- Name: modification_regulations_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.modification_regulations_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: modification_regulations_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.modification_regulations_oid_seq OWNED BY public.modification_regulations_oplog.oid;


--
-- Name: monetary_exchange_periods_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.monetary_exchange_periods_oplog (
    monetary_exchange_period_sid integer,
    parent_monetary_unit_code character varying(255),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: monetary_exchange_periods; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.monetary_exchange_periods AS
 SELECT monetary_exchange_periods1.monetary_exchange_period_sid,
    monetary_exchange_periods1.parent_monetary_unit_code,
    monetary_exchange_periods1.validity_start_date,
    monetary_exchange_periods1.validity_end_date,
    monetary_exchange_periods1.oid,
    monetary_exchange_periods1.operation,
    monetary_exchange_periods1.operation_date,
    monetary_exchange_periods1.status,
    monetary_exchange_periods1.workbasket_id,
    monetary_exchange_periods1.workbasket_sequence_number
   FROM public.monetary_exchange_periods_oplog monetary_exchange_periods1
  WHERE ((monetary_exchange_periods1.oid IN ( SELECT max(monetary_exchange_periods2.oid) AS max
           FROM public.monetary_exchange_periods_oplog monetary_exchange_periods2
          WHERE ((monetary_exchange_periods1.monetary_exchange_period_sid = monetary_exchange_periods2.monetary_exchange_period_sid) AND ((monetary_exchange_periods1.parent_monetary_unit_code)::text = (monetary_exchange_periods2.parent_monetary_unit_code)::text)))) AND ((monetary_exchange_periods1.operation)::text <> 'D'::text));


--
-- Name: monetary_exchange_periods_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.monetary_exchange_periods_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: monetary_exchange_periods_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.monetary_exchange_periods_oid_seq OWNED BY public.monetary_exchange_periods_oplog.oid;


--
-- Name: monetary_exchange_rates_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.monetary_exchange_rates_oplog (
    monetary_exchange_period_sid integer,
    child_monetary_unit_code character varying(255),
    exchange_rate numeric(16,8),
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: monetary_exchange_rates; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.monetary_exchange_rates AS
 SELECT monetary_exchange_rates1.monetary_exchange_period_sid,
    monetary_exchange_rates1.child_monetary_unit_code,
    monetary_exchange_rates1.exchange_rate,
    monetary_exchange_rates1.oid,
    monetary_exchange_rates1.operation,
    monetary_exchange_rates1.operation_date,
    monetary_exchange_rates1.status,
    monetary_exchange_rates1.workbasket_id,
    monetary_exchange_rates1.workbasket_sequence_number
   FROM public.monetary_exchange_rates_oplog monetary_exchange_rates1
  WHERE ((monetary_exchange_rates1.oid IN ( SELECT max(monetary_exchange_rates2.oid) AS max
           FROM public.monetary_exchange_rates_oplog monetary_exchange_rates2
          WHERE ((monetary_exchange_rates1.monetary_exchange_period_sid = monetary_exchange_rates2.monetary_exchange_period_sid) AND ((monetary_exchange_rates1.child_monetary_unit_code)::text = (monetary_exchange_rates2.child_monetary_unit_code)::text)))) AND ((monetary_exchange_rates1.operation)::text <> 'D'::text));


--
-- Name: monetary_exchange_rates_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.monetary_exchange_rates_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: monetary_exchange_rates_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.monetary_exchange_rates_oid_seq OWNED BY public.monetary_exchange_rates_oplog.oid;


--
-- Name: monetary_unit_descriptions_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.monetary_unit_descriptions_oplog (
    monetary_unit_code character varying(255),
    language_id character varying(5),
    description text,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: monetary_unit_descriptions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.monetary_unit_descriptions AS
 SELECT monetary_unit_descriptions1.monetary_unit_code,
    monetary_unit_descriptions1.language_id,
    monetary_unit_descriptions1.description,
    monetary_unit_descriptions1.oid,
    monetary_unit_descriptions1.operation,
    monetary_unit_descriptions1.operation_date,
    monetary_unit_descriptions1.status,
    monetary_unit_descriptions1.workbasket_id,
    monetary_unit_descriptions1.workbasket_sequence_number
   FROM public.monetary_unit_descriptions_oplog monetary_unit_descriptions1
  WHERE ((monetary_unit_descriptions1.oid IN ( SELECT max(monetary_unit_descriptions2.oid) AS max
           FROM public.monetary_unit_descriptions_oplog monetary_unit_descriptions2
          WHERE ((monetary_unit_descriptions1.monetary_unit_code)::text = (monetary_unit_descriptions2.monetary_unit_code)::text))) AND ((monetary_unit_descriptions1.operation)::text <> 'D'::text));


--
-- Name: monetary_unit_descriptions_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.monetary_unit_descriptions_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: monetary_unit_descriptions_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.monetary_unit_descriptions_oid_seq OWNED BY public.monetary_unit_descriptions_oplog.oid;


--
-- Name: monetary_units_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.monetary_units_oplog (
    monetary_unit_code character varying(255),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: monetary_units; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.monetary_units AS
 SELECT monetary_units1.monetary_unit_code,
    monetary_units1.validity_start_date,
    monetary_units1.validity_end_date,
    monetary_units1.oid,
    monetary_units1.operation,
    monetary_units1.operation_date,
    monetary_units1.status,
    monetary_units1.workbasket_id,
    monetary_units1.workbasket_sequence_number
   FROM public.monetary_units_oplog monetary_units1
  WHERE ((monetary_units1.oid IN ( SELECT max(monetary_units2.oid) AS max
           FROM public.monetary_units_oplog monetary_units2
          WHERE ((monetary_units1.monetary_unit_code)::text = (monetary_units2.monetary_unit_code)::text))) AND ((monetary_units1.operation)::text <> 'D'::text));


--
-- Name: monetary_units_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.monetary_units_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: monetary_units_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.monetary_units_oid_seq OWNED BY public.monetary_units_oplog.oid;


--
-- Name: nomenclature_group_memberships_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nomenclature_group_memberships_oplog (
    goods_nomenclature_sid integer,
    goods_nomenclature_group_type character varying(1),
    goods_nomenclature_group_id character varying(6),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    goods_nomenclature_item_id character varying(10),
    productline_suffix character varying(2),
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: nomenclature_group_memberships; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.nomenclature_group_memberships AS
 SELECT nomenclature_group_memberships1.goods_nomenclature_sid,
    nomenclature_group_memberships1.goods_nomenclature_group_type,
    nomenclature_group_memberships1.goods_nomenclature_group_id,
    nomenclature_group_memberships1.validity_start_date,
    nomenclature_group_memberships1.validity_end_date,
    nomenclature_group_memberships1.goods_nomenclature_item_id,
    nomenclature_group_memberships1.productline_suffix,
    nomenclature_group_memberships1.oid,
    nomenclature_group_memberships1.operation,
    nomenclature_group_memberships1.operation_date,
    nomenclature_group_memberships1.status,
    nomenclature_group_memberships1.workbasket_id,
    nomenclature_group_memberships1.workbasket_sequence_number
   FROM public.nomenclature_group_memberships_oplog nomenclature_group_memberships1
  WHERE ((nomenclature_group_memberships1.oid IN ( SELECT max(nomenclature_group_memberships2.oid) AS max
           FROM public.nomenclature_group_memberships_oplog nomenclature_group_memberships2
          WHERE ((nomenclature_group_memberships1.goods_nomenclature_sid = nomenclature_group_memberships2.goods_nomenclature_sid) AND ((nomenclature_group_memberships1.goods_nomenclature_group_id)::text = (nomenclature_group_memberships2.goods_nomenclature_group_id)::text) AND ((nomenclature_group_memberships1.goods_nomenclature_group_type)::text = (nomenclature_group_memberships2.goods_nomenclature_group_type)::text) AND ((nomenclature_group_memberships1.goods_nomenclature_item_id)::text = (nomenclature_group_memberships2.goods_nomenclature_item_id)::text) AND (nomenclature_group_memberships1.validity_start_date = nomenclature_group_memberships2.validity_start_date)))) AND ((nomenclature_group_memberships1.operation)::text <> 'D'::text));


--
-- Name: nomenclature_group_memberships_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.nomenclature_group_memberships_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: nomenclature_group_memberships_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.nomenclature_group_memberships_oid_seq OWNED BY public.nomenclature_group_memberships_oplog.oid;


--
-- Name: prorogation_regulation_actions_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.prorogation_regulation_actions_oplog (
    prorogation_regulation_role integer,
    prorogation_regulation_id character varying(8),
    prorogated_regulation_role integer,
    prorogated_regulation_id character varying(8),
    prorogated_date date,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: prorogation_regulation_actions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.prorogation_regulation_actions AS
 SELECT prorogation_regulation_actions1.prorogation_regulation_role,
    prorogation_regulation_actions1.prorogation_regulation_id,
    prorogation_regulation_actions1.prorogated_regulation_role,
    prorogation_regulation_actions1.prorogated_regulation_id,
    prorogation_regulation_actions1.prorogated_date,
    prorogation_regulation_actions1.oid,
    prorogation_regulation_actions1.operation,
    prorogation_regulation_actions1.operation_date,
    prorogation_regulation_actions1.status,
    prorogation_regulation_actions1.workbasket_id,
    prorogation_regulation_actions1.workbasket_sequence_number
   FROM public.prorogation_regulation_actions_oplog prorogation_regulation_actions1
  WHERE ((prorogation_regulation_actions1.oid IN ( SELECT max(prorogation_regulation_actions2.oid) AS max
           FROM public.prorogation_regulation_actions_oplog prorogation_regulation_actions2
          WHERE (((prorogation_regulation_actions1.prorogation_regulation_id)::text = (prorogation_regulation_actions2.prorogation_regulation_id)::text) AND (prorogation_regulation_actions1.prorogation_regulation_role = prorogation_regulation_actions2.prorogation_regulation_role) AND ((prorogation_regulation_actions1.prorogated_regulation_id)::text = (prorogation_regulation_actions2.prorogated_regulation_id)::text) AND (prorogation_regulation_actions1.prorogated_regulation_role = prorogation_regulation_actions2.prorogated_regulation_role)))) AND ((prorogation_regulation_actions1.operation)::text <> 'D'::text));


--
-- Name: prorogation_regulation_actions_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.prorogation_regulation_actions_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prorogation_regulation_actions_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.prorogation_regulation_actions_oid_seq OWNED BY public.prorogation_regulation_actions_oplog.oid;


--
-- Name: prorogation_regulations_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.prorogation_regulations_oplog (
    prorogation_regulation_role integer,
    prorogation_regulation_id character varying(255),
    published_date date,
    officialjournal_number character varying(255),
    officialjournal_page integer,
    replacement_indicator integer,
    information_text text,
    approved_flag boolean,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    added_by_id integer,
    added_at timestamp without time zone,
    "national" boolean,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: prorogation_regulations; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.prorogation_regulations AS
 SELECT prorogation_regulations1.prorogation_regulation_role,
    prorogation_regulations1.prorogation_regulation_id,
    prorogation_regulations1.published_date,
    prorogation_regulations1.officialjournal_number,
    prorogation_regulations1.officialjournal_page,
    prorogation_regulations1.replacement_indicator,
    prorogation_regulations1.information_text,
    prorogation_regulations1.approved_flag,
    prorogation_regulations1.oid,
    prorogation_regulations1.operation,
    prorogation_regulations1.operation_date,
    prorogation_regulations1.added_by_id,
    prorogation_regulations1.added_at,
    prorogation_regulations1."national",
    prorogation_regulations1.status,
    prorogation_regulations1.workbasket_id,
    prorogation_regulations1.workbasket_sequence_number
   FROM public.prorogation_regulations_oplog prorogation_regulations1
  WHERE ((prorogation_regulations1.oid IN ( SELECT max(prorogation_regulations2.oid) AS max
           FROM public.prorogation_regulations_oplog prorogation_regulations2
          WHERE (((prorogation_regulations1.prorogation_regulation_id)::text = (prorogation_regulations2.prorogation_regulation_id)::text) AND (prorogation_regulations1.prorogation_regulation_role = prorogation_regulations2.prorogation_regulation_role)))) AND ((prorogation_regulations1.operation)::text <> 'D'::text));


--
-- Name: prorogation_regulations_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.prorogation_regulations_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prorogation_regulations_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.prorogation_regulations_oid_seq OWNED BY public.prorogation_regulations_oplog.oid;


--
-- Name: publication_sigles_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.publication_sigles_oplog (
    oid integer NOT NULL,
    code_type_id character varying(4),
    code character varying(10),
    publication_code character varying(1),
    publication_sigle character varying(20),
    validity_end_date timestamp without time zone,
    validity_start_date timestamp without time zone,
    created_at timestamp without time zone,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: publication_sigles; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.publication_sigles AS
 SELECT publication_sigles1.oid,
    publication_sigles1.code_type_id,
    publication_sigles1.code,
    publication_sigles1.publication_code,
    publication_sigles1.publication_sigle,
    publication_sigles1.validity_end_date,
    publication_sigles1.validity_start_date,
    publication_sigles1.operation,
    publication_sigles1.operation_date,
    publication_sigles1.status,
    publication_sigles1.workbasket_id,
    publication_sigles1.workbasket_sequence_number
   FROM public.publication_sigles_oplog publication_sigles1
  WHERE ((publication_sigles1.oid IN ( SELECT max(publication_sigles2.oid) AS max
           FROM public.publication_sigles_oplog publication_sigles2
          WHERE (((publication_sigles1.code)::text = (publication_sigles2.code)::text) AND ((publication_sigles1.code_type_id)::text = (publication_sigles2.code_type_id)::text)))) AND ((publication_sigles1.operation)::text <> 'D'::text));


--
-- Name: publication_sigles_oplog_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.publication_sigles_oplog_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: publication_sigles_oplog_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.publication_sigles_oplog_oid_seq OWNED BY public.publication_sigles_oplog.oid;


--
-- Name: quota_associations_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quota_associations_oplog (
    main_quota_definition_sid integer,
    sub_quota_definition_sid integer,
    relation_type character varying(255),
    coefficient numeric(16,5),
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer,
    added_by_id integer,
    added_at timestamp without time zone,
    "national" boolean
);


--
-- Name: quota_associations; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.quota_associations AS
 SELECT quota_associations1.main_quota_definition_sid,
    quota_associations1.sub_quota_definition_sid,
    quota_associations1.relation_type,
    quota_associations1.coefficient,
    quota_associations1.oid,
    quota_associations1.operation,
    quota_associations1.operation_date,
    quota_associations1.status,
    quota_associations1.workbasket_id,
    quota_associations1.workbasket_sequence_number,
    quota_associations1.added_by_id,
    quota_associations1.added_at,
    quota_associations1."national"
   FROM public.quota_associations_oplog quota_associations1
  WHERE ((quota_associations1.oid IN ( SELECT max(quota_associations2.oid) AS max
           FROM public.quota_associations_oplog quota_associations2
          WHERE ((quota_associations1.main_quota_definition_sid = quota_associations2.main_quota_definition_sid) AND (quota_associations1.sub_quota_definition_sid = quota_associations2.sub_quota_definition_sid)))) AND ((quota_associations1.operation)::text <> 'D'::text));


--
-- Name: quota_associations_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quota_associations_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quota_associations_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quota_associations_oid_seq OWNED BY public.quota_associations_oplog.oid;


--
-- Name: quota_balance_events_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quota_balance_events_oplog (
    quota_definition_sid integer,
    occurrence_timestamp timestamp without time zone,
    last_import_date_in_allocation date,
    old_balance numeric(15,3),
    new_balance numeric(15,3),
    imported_amount numeric(15,3),
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: quota_balance_events; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.quota_balance_events AS
 SELECT quota_balance_events1.quota_definition_sid,
    quota_balance_events1.occurrence_timestamp,
    quota_balance_events1.last_import_date_in_allocation,
    quota_balance_events1.old_balance,
    quota_balance_events1.new_balance,
    quota_balance_events1.imported_amount,
    quota_balance_events1.oid,
    quota_balance_events1.operation,
    quota_balance_events1.operation_date,
    quota_balance_events1.status,
    quota_balance_events1.workbasket_id,
    quota_balance_events1.workbasket_sequence_number
   FROM public.quota_balance_events_oplog quota_balance_events1
  WHERE ((quota_balance_events1.oid IN ( SELECT max(quota_balance_events2.oid) AS max
           FROM public.quota_balance_events_oplog quota_balance_events2
          WHERE ((quota_balance_events1.quota_definition_sid = quota_balance_events2.quota_definition_sid) AND (quota_balance_events1.occurrence_timestamp = quota_balance_events2.occurrence_timestamp)))) AND ((quota_balance_events1.operation)::text <> 'D'::text));


--
-- Name: quota_balance_events_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quota_balance_events_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quota_balance_events_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quota_balance_events_oid_seq OWNED BY public.quota_balance_events_oplog.oid;


--
-- Name: quota_blocking_periods_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quota_blocking_periods_oplog (
    quota_blocking_period_sid integer,
    quota_definition_sid integer,
    blocking_start_date date,
    blocking_end_date date,
    blocking_period_type integer,
    description text,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: quota_blocking_periods; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.quota_blocking_periods AS
 SELECT quota_blocking_periods1.quota_blocking_period_sid,
    quota_blocking_periods1.quota_definition_sid,
    quota_blocking_periods1.blocking_start_date,
    quota_blocking_periods1.blocking_end_date,
    quota_blocking_periods1.blocking_period_type,
    quota_blocking_periods1.description,
    quota_blocking_periods1.oid,
    quota_blocking_periods1.operation,
    quota_blocking_periods1.operation_date,
    quota_blocking_periods1.status,
    quota_blocking_periods1.workbasket_id,
    quota_blocking_periods1.workbasket_sequence_number
   FROM public.quota_blocking_periods_oplog quota_blocking_periods1
  WHERE ((quota_blocking_periods1.oid IN ( SELECT max(quota_blocking_periods2.oid) AS max
           FROM public.quota_blocking_periods_oplog quota_blocking_periods2
          WHERE (quota_blocking_periods1.quota_blocking_period_sid = quota_blocking_periods2.quota_blocking_period_sid))) AND ((quota_blocking_periods1.operation)::text <> 'D'::text));


--
-- Name: quota_blocking_periods_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quota_blocking_periods_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quota_blocking_periods_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quota_blocking_periods_oid_seq OWNED BY public.quota_blocking_periods_oplog.oid;


--
-- Name: quota_critical_events_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quota_critical_events_oplog (
    quota_definition_sid integer,
    occurrence_timestamp timestamp without time zone,
    critical_state character varying(255),
    critical_state_change_date date,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: quota_critical_events; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.quota_critical_events AS
 SELECT quota_critical_events1.quota_definition_sid,
    quota_critical_events1.occurrence_timestamp,
    quota_critical_events1.critical_state,
    quota_critical_events1.critical_state_change_date,
    quota_critical_events1.oid,
    quota_critical_events1.operation,
    quota_critical_events1.operation_date,
    quota_critical_events1.status,
    quota_critical_events1.workbasket_id,
    quota_critical_events1.workbasket_sequence_number
   FROM public.quota_critical_events_oplog quota_critical_events1
  WHERE ((quota_critical_events1.oid IN ( SELECT max(quota_critical_events2.oid) AS max
           FROM public.quota_critical_events_oplog quota_critical_events2
          WHERE ((quota_critical_events1.quota_definition_sid = quota_critical_events2.quota_definition_sid) AND (quota_critical_events1.occurrence_timestamp = quota_critical_events2.occurrence_timestamp)))) AND ((quota_critical_events1.operation)::text <> 'D'::text));


--
-- Name: quota_critical_events_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quota_critical_events_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quota_critical_events_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quota_critical_events_oid_seq OWNED BY public.quota_critical_events_oplog.oid;


--
-- Name: quota_definitions_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quota_definitions_oplog (
    quota_definition_sid integer,
    quota_order_number_id character varying(255),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    quota_order_number_sid integer,
    volume numeric(12,2),
    initial_volume numeric(12,2),
    measurement_unit_code character varying(3),
    maximum_precision integer,
    critical_state character varying(255),
    critical_threshold integer,
    monetary_unit_code character varying(255),
    measurement_unit_qualifier_code character varying(1),
    description text,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    added_by_id integer,
    added_at timestamp without time zone,
    "national" boolean,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer,
    workbasket_type_of_quota text
);


--
-- Name: quota_definitions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.quota_definitions AS
 SELECT quota_definitions1.quota_definition_sid,
    quota_definitions1.quota_order_number_id,
    quota_definitions1.validity_start_date,
    quota_definitions1.validity_end_date,
    quota_definitions1.quota_order_number_sid,
    quota_definitions1.volume,
    quota_definitions1.initial_volume,
    quota_definitions1.measurement_unit_code,
    quota_definitions1.maximum_precision,
    quota_definitions1.critical_state,
    quota_definitions1.critical_threshold,
    quota_definitions1.monetary_unit_code,
    quota_definitions1.measurement_unit_qualifier_code,
    quota_definitions1.description,
    quota_definitions1.oid,
    quota_definitions1.operation,
    quota_definitions1.operation_date,
    quota_definitions1.added_by_id,
    quota_definitions1.added_at,
    quota_definitions1."national",
    quota_definitions1.status,
    quota_definitions1.workbasket_id,
    quota_definitions1.workbasket_sequence_number,
    quota_definitions1.workbasket_type_of_quota
   FROM public.quota_definitions_oplog quota_definitions1
  WHERE ((quota_definitions1.oid IN ( SELECT max(quota_definitions2.oid) AS max
           FROM public.quota_definitions_oplog quota_definitions2
          WHERE (quota_definitions1.quota_definition_sid = quota_definitions2.quota_definition_sid))) AND ((quota_definitions1.operation)::text <> 'D'::text));


--
-- Name: quota_definitions_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quota_definitions_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quota_definitions_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quota_definitions_oid_seq OWNED BY public.quota_definitions_oplog.oid;


--
-- Name: quota_exhaustion_events_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quota_exhaustion_events_oplog (
    quota_definition_sid integer,
    occurrence_timestamp timestamp without time zone,
    exhaustion_date date,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: quota_exhaustion_events; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.quota_exhaustion_events AS
 SELECT quota_exhaustion_events1.quota_definition_sid,
    quota_exhaustion_events1.occurrence_timestamp,
    quota_exhaustion_events1.exhaustion_date,
    quota_exhaustion_events1.oid,
    quota_exhaustion_events1.operation,
    quota_exhaustion_events1.operation_date,
    quota_exhaustion_events1.status,
    quota_exhaustion_events1.workbasket_id,
    quota_exhaustion_events1.workbasket_sequence_number
   FROM public.quota_exhaustion_events_oplog quota_exhaustion_events1
  WHERE ((quota_exhaustion_events1.oid IN ( SELECT max(quota_exhaustion_events2.oid) AS max
           FROM public.quota_exhaustion_events_oplog quota_exhaustion_events2
          WHERE (quota_exhaustion_events1.quota_definition_sid = quota_exhaustion_events2.quota_definition_sid))) AND ((quota_exhaustion_events1.operation)::text <> 'D'::text));


--
-- Name: quota_exhaustion_events_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quota_exhaustion_events_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quota_exhaustion_events_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quota_exhaustion_events_oid_seq OWNED BY public.quota_exhaustion_events_oplog.oid;


--
-- Name: quota_order_number_origin_exclusions_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quota_order_number_origin_exclusions_oplog (
    quota_order_number_origin_sid integer,
    excluded_geographical_area_sid integer,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    added_by_id integer,
    added_at timestamp without time zone,
    "national" boolean,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: quota_order_number_origin_exclusions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.quota_order_number_origin_exclusions AS
 SELECT quota_order_number_origin_exclusions1.quota_order_number_origin_sid,
    quota_order_number_origin_exclusions1.excluded_geographical_area_sid,
    quota_order_number_origin_exclusions1.oid,
    quota_order_number_origin_exclusions1.operation,
    quota_order_number_origin_exclusions1.operation_date,
    quota_order_number_origin_exclusions1.added_by_id,
    quota_order_number_origin_exclusions1.added_at,
    quota_order_number_origin_exclusions1."national",
    quota_order_number_origin_exclusions1.status,
    quota_order_number_origin_exclusions1.workbasket_id,
    quota_order_number_origin_exclusions1.workbasket_sequence_number
   FROM public.quota_order_number_origin_exclusions_oplog quota_order_number_origin_exclusions1
  WHERE ((quota_order_number_origin_exclusions1.oid IN ( SELECT max(quota_order_number_origin_exclusions2.oid) AS max
           FROM public.quota_order_number_origin_exclusions_oplog quota_order_number_origin_exclusions2
          WHERE ((quota_order_number_origin_exclusions1.quota_order_number_origin_sid = quota_order_number_origin_exclusions2.quota_order_number_origin_sid) AND (quota_order_number_origin_exclusions1.excluded_geographical_area_sid = quota_order_number_origin_exclusions2.excluded_geographical_area_sid)))) AND ((quota_order_number_origin_exclusions1.operation)::text <> 'D'::text));


--
-- Name: quota_order_number_origin_exclusions_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quota_order_number_origin_exclusions_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quota_order_number_origin_exclusions_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quota_order_number_origin_exclusions_oid_seq OWNED BY public.quota_order_number_origin_exclusions_oplog.oid;


--
-- Name: quota_order_number_origins_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quota_order_number_origins_oplog (
    quota_order_number_origin_sid integer,
    quota_order_number_sid integer,
    geographical_area_id character varying(255),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    geographical_area_sid integer,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    added_by_id integer,
    added_at timestamp without time zone,
    "national" boolean,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: quota_order_number_origins; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.quota_order_number_origins AS
 SELECT quota_order_number_origins1.quota_order_number_origin_sid,
    quota_order_number_origins1.quota_order_number_sid,
    quota_order_number_origins1.geographical_area_id,
    quota_order_number_origins1.validity_start_date,
    quota_order_number_origins1.validity_end_date,
    quota_order_number_origins1.geographical_area_sid,
    quota_order_number_origins1.oid,
    quota_order_number_origins1.operation,
    quota_order_number_origins1.operation_date,
    quota_order_number_origins1.added_by_id,
    quota_order_number_origins1.added_at,
    quota_order_number_origins1."national",
    quota_order_number_origins1.status,
    quota_order_number_origins1.workbasket_id,
    quota_order_number_origins1.workbasket_sequence_number
   FROM public.quota_order_number_origins_oplog quota_order_number_origins1
  WHERE ((quota_order_number_origins1.oid IN ( SELECT max(quota_order_number_origins2.oid) AS max
           FROM public.quota_order_number_origins_oplog quota_order_number_origins2
          WHERE (quota_order_number_origins1.quota_order_number_origin_sid = quota_order_number_origins2.quota_order_number_origin_sid))) AND ((quota_order_number_origins1.operation)::text <> 'D'::text));


--
-- Name: quota_order_number_origins_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quota_order_number_origins_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quota_order_number_origins_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quota_order_number_origins_oid_seq OWNED BY public.quota_order_number_origins_oplog.oid;


--
-- Name: quota_order_numbers_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quota_order_numbers_oplog (
    quota_order_number_sid integer,
    quota_order_number_id character varying(255),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    added_by_id integer,
    added_at timestamp without time zone,
    "national" boolean,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: quota_order_numbers; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.quota_order_numbers AS
 SELECT quota_order_numbers1.quota_order_number_sid,
    quota_order_numbers1.quota_order_number_id,
    quota_order_numbers1.validity_start_date,
    quota_order_numbers1.validity_end_date,
    quota_order_numbers1.oid,
    quota_order_numbers1.operation,
    quota_order_numbers1.operation_date,
    quota_order_numbers1.added_by_id,
    quota_order_numbers1.added_at,
    quota_order_numbers1."national",
    quota_order_numbers1.status,
    quota_order_numbers1.workbasket_id,
    quota_order_numbers1.workbasket_sequence_number
   FROM public.quota_order_numbers_oplog quota_order_numbers1
  WHERE ((quota_order_numbers1.oid IN ( SELECT max(quota_order_numbers2.oid) AS max
           FROM public.quota_order_numbers_oplog quota_order_numbers2
          WHERE (quota_order_numbers1.quota_order_number_sid = quota_order_numbers2.quota_order_number_sid))) AND ((quota_order_numbers1.operation)::text <> 'D'::text));


--
-- Name: quota_order_numbers_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quota_order_numbers_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quota_order_numbers_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quota_order_numbers_oid_seq OWNED BY public.quota_order_numbers_oplog.oid;


--
-- Name: quota_reopening_events_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quota_reopening_events_oplog (
    quota_definition_sid integer,
    occurrence_timestamp timestamp without time zone,
    reopening_date date,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: quota_reopening_events; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.quota_reopening_events AS
 SELECT quota_reopening_events1.quota_definition_sid,
    quota_reopening_events1.occurrence_timestamp,
    quota_reopening_events1.reopening_date,
    quota_reopening_events1.oid,
    quota_reopening_events1.operation,
    quota_reopening_events1.operation_date,
    quota_reopening_events1.status,
    quota_reopening_events1.workbasket_id,
    quota_reopening_events1.workbasket_sequence_number
   FROM public.quota_reopening_events_oplog quota_reopening_events1
  WHERE ((quota_reopening_events1.oid IN ( SELECT max(quota_reopening_events2.oid) AS max
           FROM public.quota_reopening_events_oplog quota_reopening_events2
          WHERE (quota_reopening_events1.quota_definition_sid = quota_reopening_events2.quota_definition_sid))) AND ((quota_reopening_events1.operation)::text <> 'D'::text));


--
-- Name: quota_reopening_events_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quota_reopening_events_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quota_reopening_events_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quota_reopening_events_oid_seq OWNED BY public.quota_reopening_events_oplog.oid;


--
-- Name: quota_suspension_periods_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quota_suspension_periods_oplog (
    quota_suspension_period_sid integer,
    quota_definition_sid integer,
    suspension_start_date date,
    suspension_end_date date,
    description text,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer,
    added_by_id integer,
    added_at timestamp without time zone,
    "national" boolean
);


--
-- Name: quota_suspension_periods; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.quota_suspension_periods AS
 SELECT quota_suspension_periods1.quota_suspension_period_sid,
    quota_suspension_periods1.quota_definition_sid,
    quota_suspension_periods1.suspension_start_date,
    quota_suspension_periods1.suspension_end_date,
    quota_suspension_periods1.description,
    quota_suspension_periods1.oid,
    quota_suspension_periods1.operation,
    quota_suspension_periods1.operation_date,
    quota_suspension_periods1.status,
    quota_suspension_periods1.workbasket_id,
    quota_suspension_periods1.workbasket_sequence_number,
    quota_suspension_periods1.added_by_id,
    quota_suspension_periods1.added_at,
    quota_suspension_periods1."national"
   FROM public.quota_suspension_periods_oplog quota_suspension_periods1
  WHERE ((quota_suspension_periods1.oid IN ( SELECT max(quota_suspension_periods2.oid) AS max
           FROM public.quota_suspension_periods_oplog quota_suspension_periods2
          WHERE (quota_suspension_periods1.quota_suspension_period_sid = quota_suspension_periods2.quota_suspension_period_sid))) AND ((quota_suspension_periods1.operation)::text <> 'D'::text));


--
-- Name: quota_suspension_periods_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quota_suspension_periods_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quota_suspension_periods_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quota_suspension_periods_oid_seq OWNED BY public.quota_suspension_periods_oplog.oid;


--
-- Name: quota_unblocking_events_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quota_unblocking_events_oplog (
    quota_definition_sid integer,
    occurrence_timestamp timestamp without time zone,
    unblocking_date date,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: quota_unblocking_events; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.quota_unblocking_events AS
 SELECT quota_unblocking_events1.quota_definition_sid,
    quota_unblocking_events1.occurrence_timestamp,
    quota_unblocking_events1.unblocking_date,
    quota_unblocking_events1.oid,
    quota_unblocking_events1.operation,
    quota_unblocking_events1.operation_date,
    quota_unblocking_events1.status,
    quota_unblocking_events1.workbasket_id,
    quota_unblocking_events1.workbasket_sequence_number
   FROM public.quota_unblocking_events_oplog quota_unblocking_events1
  WHERE ((quota_unblocking_events1.oid IN ( SELECT max(quota_unblocking_events2.oid) AS max
           FROM public.quota_unblocking_events_oplog quota_unblocking_events2
          WHERE (quota_unblocking_events1.quota_definition_sid = quota_unblocking_events2.quota_definition_sid))) AND ((quota_unblocking_events1.operation)::text <> 'D'::text));


--
-- Name: quota_unblocking_events_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quota_unblocking_events_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quota_unblocking_events_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quota_unblocking_events_oid_seq OWNED BY public.quota_unblocking_events_oplog.oid;


--
-- Name: quota_unsuspension_events_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quota_unsuspension_events_oplog (
    quota_definition_sid integer,
    occurrence_timestamp timestamp without time zone,
    unsuspension_date date,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer,
    added_by_id integer,
    added_at timestamp without time zone,
    "national" boolean
);


--
-- Name: quota_unsuspension_events; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.quota_unsuspension_events AS
 SELECT quota_unsuspension_events1.quota_definition_sid,
    quota_unsuspension_events1.occurrence_timestamp,
    quota_unsuspension_events1.unsuspension_date,
    quota_unsuspension_events1.oid,
    quota_unsuspension_events1.operation,
    quota_unsuspension_events1.operation_date,
    quota_unsuspension_events1.status,
    quota_unsuspension_events1.workbasket_id,
    quota_unsuspension_events1.workbasket_sequence_number,
    quota_unsuspension_events1.added_by_id,
    quota_unsuspension_events1.added_at,
    quota_unsuspension_events1."national"
   FROM public.quota_unsuspension_events_oplog quota_unsuspension_events1
  WHERE ((quota_unsuspension_events1.oid IN ( SELECT max(quota_unsuspension_events2.oid) AS max
           FROM public.quota_unsuspension_events_oplog quota_unsuspension_events2
          WHERE (quota_unsuspension_events1.quota_definition_sid = quota_unsuspension_events2.quota_definition_sid))) AND ((quota_unsuspension_events1.operation)::text <> 'D'::text));


--
-- Name: quota_unsuspension_events_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quota_unsuspension_events_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quota_unsuspension_events_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quota_unsuspension_events_oid_seq OWNED BY public.quota_unsuspension_events_oplog.oid;


--
-- Name: regulation_documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regulation_documents (
    id integer NOT NULL,
    regulation_id text,
    regulation_role text,
    regulation_id_key text,
    regulation_role_key text,
    pdf_data text,
    updated_at timestamp without time zone,
    created_at timestamp without time zone,
    "national" boolean
);


--
-- Name: regulation_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regulation_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regulation_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.regulation_documents_id_seq OWNED BY public.regulation_documents.id;


--
-- Name: regulation_group_descriptions_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regulation_group_descriptions_oplog (
    regulation_group_id character varying(255),
    language_id character varying(5),
    description text,
    created_at timestamp without time zone,
    "national" boolean,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: regulation_group_descriptions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.regulation_group_descriptions AS
 SELECT regulation_group_descriptions1.regulation_group_id,
    regulation_group_descriptions1.language_id,
    regulation_group_descriptions1.description,
    regulation_group_descriptions1."national",
    regulation_group_descriptions1.oid,
    regulation_group_descriptions1.operation,
    regulation_group_descriptions1.operation_date,
    regulation_group_descriptions1.status,
    regulation_group_descriptions1.workbasket_id,
    regulation_group_descriptions1.workbasket_sequence_number
   FROM public.regulation_group_descriptions_oplog regulation_group_descriptions1
  WHERE ((regulation_group_descriptions1.oid IN ( SELECT max(regulation_group_descriptions2.oid) AS max
           FROM public.regulation_group_descriptions_oplog regulation_group_descriptions2
          WHERE ((regulation_group_descriptions1.regulation_group_id)::text = (regulation_group_descriptions2.regulation_group_id)::text))) AND ((regulation_group_descriptions1.operation)::text <> 'D'::text));


--
-- Name: regulation_group_descriptions_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regulation_group_descriptions_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regulation_group_descriptions_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.regulation_group_descriptions_oid_seq OWNED BY public.regulation_group_descriptions_oplog.oid;


--
-- Name: regulation_groups_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regulation_groups_oplog (
    regulation_group_id character varying(255),
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    created_at timestamp without time zone,
    "national" boolean,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: regulation_groups; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.regulation_groups AS
 SELECT regulation_groups1.regulation_group_id,
    regulation_groups1.validity_start_date,
    regulation_groups1.validity_end_date,
    regulation_groups1."national",
    regulation_groups1.oid,
    regulation_groups1.operation,
    regulation_groups1.operation_date,
    regulation_groups1.status,
    regulation_groups1.workbasket_id,
    regulation_groups1.workbasket_sequence_number
   FROM public.regulation_groups_oplog regulation_groups1
  WHERE ((regulation_groups1.oid IN ( SELECT max(regulation_groups2.oid) AS max
           FROM public.regulation_groups_oplog regulation_groups2
          WHERE ((regulation_groups1.regulation_group_id)::text = (regulation_groups2.regulation_group_id)::text))) AND ((regulation_groups1.operation)::text <> 'D'::text));


--
-- Name: regulation_groups_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regulation_groups_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regulation_groups_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.regulation_groups_oid_seq OWNED BY public.regulation_groups_oplog.oid;


--
-- Name: regulation_replacements_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regulation_replacements_oplog (
    geographical_area_id character varying(255),
    chapter_heading character varying(255),
    replacing_regulation_role integer,
    replacing_regulation_id character varying(255),
    replaced_regulation_role integer,
    replaced_regulation_id character varying(255),
    measure_type_id character varying(3),
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: regulation_replacements; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.regulation_replacements AS
 SELECT regulation_replacements1.geographical_area_id,
    regulation_replacements1.chapter_heading,
    regulation_replacements1.replacing_regulation_role,
    regulation_replacements1.replacing_regulation_id,
    regulation_replacements1.replaced_regulation_role,
    regulation_replacements1.replaced_regulation_id,
    regulation_replacements1.measure_type_id,
    regulation_replacements1.oid,
    regulation_replacements1.operation,
    regulation_replacements1.operation_date,
    regulation_replacements1.status,
    regulation_replacements1.workbasket_id,
    regulation_replacements1.workbasket_sequence_number
   FROM public.regulation_replacements_oplog regulation_replacements1
  WHERE ((regulation_replacements1.oid IN ( SELECT max(regulation_replacements2.oid) AS max
           FROM public.regulation_replacements_oplog regulation_replacements2
          WHERE (((regulation_replacements1.replacing_regulation_id)::text = (regulation_replacements2.replacing_regulation_id)::text) AND (regulation_replacements1.replacing_regulation_role = regulation_replacements2.replacing_regulation_role) AND ((regulation_replacements1.replaced_regulation_id)::text = (regulation_replacements2.replaced_regulation_id)::text) AND (regulation_replacements1.replaced_regulation_role = regulation_replacements2.replaced_regulation_role)))) AND ((regulation_replacements1.operation)::text <> 'D'::text));


--
-- Name: regulation_replacements_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regulation_replacements_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regulation_replacements_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.regulation_replacements_oid_seq OWNED BY public.regulation_replacements_oplog.oid;


--
-- Name: regulation_role_type_descriptions_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regulation_role_type_descriptions_oplog (
    regulation_role_type_id character varying(255),
    language_id character varying(5),
    description text,
    created_at timestamp without time zone,
    "national" boolean,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: regulation_role_type_descriptions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.regulation_role_type_descriptions AS
 SELECT regulation_role_type_descriptions1.regulation_role_type_id,
    regulation_role_type_descriptions1.language_id,
    regulation_role_type_descriptions1.description,
    regulation_role_type_descriptions1."national",
    regulation_role_type_descriptions1.oid,
    regulation_role_type_descriptions1.operation,
    regulation_role_type_descriptions1.operation_date,
    regulation_role_type_descriptions1.status,
    regulation_role_type_descriptions1.workbasket_id,
    regulation_role_type_descriptions1.workbasket_sequence_number
   FROM public.regulation_role_type_descriptions_oplog regulation_role_type_descriptions1
  WHERE ((regulation_role_type_descriptions1.oid IN ( SELECT max(regulation_role_type_descriptions2.oid) AS max
           FROM public.regulation_role_type_descriptions_oplog regulation_role_type_descriptions2
          WHERE ((regulation_role_type_descriptions1.regulation_role_type_id)::text = (regulation_role_type_descriptions2.regulation_role_type_id)::text))) AND ((regulation_role_type_descriptions1.operation)::text <> 'D'::text));


--
-- Name: regulation_role_type_descriptions_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regulation_role_type_descriptions_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regulation_role_type_descriptions_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.regulation_role_type_descriptions_oid_seq OWNED BY public.regulation_role_type_descriptions_oplog.oid;


--
-- Name: regulation_role_types_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regulation_role_types_oplog (
    regulation_role_type_id integer,
    validity_start_date timestamp without time zone,
    validity_end_date timestamp without time zone,
    created_at timestamp without time zone,
    "national" boolean,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: regulation_role_types; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.regulation_role_types AS
 SELECT regulation_role_types1.regulation_role_type_id,
    regulation_role_types1.validity_start_date,
    regulation_role_types1.validity_end_date,
    regulation_role_types1."national",
    regulation_role_types1.oid,
    regulation_role_types1.operation,
    regulation_role_types1.operation_date,
    regulation_role_types1.status,
    regulation_role_types1.workbasket_id,
    regulation_role_types1.workbasket_sequence_number
   FROM public.regulation_role_types_oplog regulation_role_types1
  WHERE ((regulation_role_types1.oid IN ( SELECT max(regulation_role_types2.oid) AS max
           FROM public.regulation_role_types_oplog regulation_role_types2
          WHERE (regulation_role_types1.regulation_role_type_id = regulation_role_types2.regulation_role_type_id))) AND ((regulation_role_types1.operation)::text <> 'D'::text));


--
-- Name: regulation_role_types_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regulation_role_types_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regulation_role_types_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.regulation_role_types_oid_seq OWNED BY public.regulation_role_types_oplog.oid;


--
-- Name: regulations_search_pg_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.regulations_search_pg_view AS
 SELECT concat_ws('_'::text, base_regulations.oid, 'base_regulation') AS id,
    base_regulations.base_regulation_id AS regulation_id,
    base_regulations.base_regulation_role AS role,
    base_regulations.validity_start_date AS start_date,
    base_regulations.validity_end_date AS end_date,
    base_regulations.published_date,
    base_regulations.officialjournal_number,
    base_regulations.officialjournal_page,
    base_regulations.added_at,
    base_regulations.added_by_id,
    base_regulations.regulation_group_id,
    base_regulations.replacement_indicator,
    base_regulations.information_text AS keywords
   FROM public.base_regulations
UNION
 SELECT concat_ws('_'::text, modification_regulations.oid, 'modification_regulation') AS id,
    modification_regulations.modification_regulation_id AS regulation_id,
    modification_regulations.modification_regulation_role AS role,
    modification_regulations.validity_start_date AS start_date,
    modification_regulations.validity_end_date AS end_date,
    modification_regulations.published_date,
    modification_regulations.officialjournal_number,
    modification_regulations.officialjournal_page,
    modification_regulations.added_at,
    modification_regulations.added_by_id,
    NULL::character varying AS regulation_group_id,
    modification_regulations.replacement_indicator,
    modification_regulations.information_text AS keywords
   FROM public.modification_regulations
UNION
 SELECT concat_ws('_'::text, complete_abrogation_regulations.oid, 'complete_abrogation_regulation') AS id,
    complete_abrogation_regulations.complete_abrogation_regulation_id AS regulation_id,
    complete_abrogation_regulations.complete_abrogation_regulation_role AS role,
    complete_abrogation_regulations.published_date AS start_date,
    NULL::timestamp without time zone AS end_date,
    complete_abrogation_regulations.published_date,
    complete_abrogation_regulations.officialjournal_number,
    complete_abrogation_regulations.officialjournal_page,
    complete_abrogation_regulations.added_at,
    complete_abrogation_regulations.added_by_id,
    NULL::character varying AS regulation_group_id,
    complete_abrogation_regulations.replacement_indicator,
    complete_abrogation_regulations.information_text AS keywords
   FROM public.complete_abrogation_regulations
UNION
 SELECT concat_ws('_'::text, explicit_abrogation_regulations.oid, 'explicit_abrogation_regulation') AS id,
    explicit_abrogation_regulations.explicit_abrogation_regulation_id AS regulation_id,
    explicit_abrogation_regulations.explicit_abrogation_regulation_role AS role,
    explicit_abrogation_regulations.published_date AS start_date,
    NULL::timestamp without time zone AS end_date,
    explicit_abrogation_regulations.published_date,
    explicit_abrogation_regulations.officialjournal_number,
    explicit_abrogation_regulations.officialjournal_page,
    explicit_abrogation_regulations.added_at,
    explicit_abrogation_regulations.added_by_id,
    NULL::character varying AS regulation_group_id,
    explicit_abrogation_regulations.replacement_indicator,
    explicit_abrogation_regulations.information_text AS keywords
   FROM public.explicit_abrogation_regulations
UNION
 SELECT concat_ws('_'::text, prorogation_regulations.oid, 'prorogation_regulation') AS id,
    prorogation_regulations.prorogation_regulation_id AS regulation_id,
    prorogation_regulations.prorogation_regulation_role AS role,
    prorogation_regulations.published_date AS start_date,
    NULL::timestamp without time zone AS end_date,
    prorogation_regulations.published_date,
    prorogation_regulations.officialjournal_number,
    prorogation_regulations.officialjournal_page,
    prorogation_regulations.added_at,
    prorogation_regulations.added_by_id,
    NULL::character varying AS regulation_group_id,
    prorogation_regulations.replacement_indicator,
    prorogation_regulations.information_text AS keywords
   FROM public.prorogation_regulations
UNION
 SELECT concat_ws('_'::text, full_temporary_stop_regulations.oid, 'full_temporary_stop_regulation') AS id,
    full_temporary_stop_regulations.full_temporary_stop_regulation_id AS regulation_id,
    full_temporary_stop_regulations.full_temporary_stop_regulation_role AS role,
    full_temporary_stop_regulations.validity_start_date AS start_date,
    full_temporary_stop_regulations.validity_end_date AS end_date,
    full_temporary_stop_regulations.published_date,
    full_temporary_stop_regulations.officialjournal_number,
    full_temporary_stop_regulations.officialjournal_page,
    full_temporary_stop_regulations.added_at,
    full_temporary_stop_regulations.added_by_id,
    NULL::character varying AS regulation_group_id,
    full_temporary_stop_regulations.replacement_indicator,
    full_temporary_stop_regulations.information_text AS keywords
   FROM public.full_temporary_stop_regulations;


--
-- Name: rollbacks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rollbacks (
    id integer NOT NULL,
    user_id integer,
    date date,
    enqueued_at timestamp without time zone,
    reason text,
    keep boolean
);


--
-- Name: rollbacks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rollbacks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rollbacks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rollbacks_id_seq OWNED BY public.rollbacks.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    filename text NOT NULL
);


--
-- Name: search_references; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.search_references (
    id integer NOT NULL,
    title text,
    referenced_id character varying(10),
    referenced_class character varying(10)
);


--
-- Name: search_references_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.search_references_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: search_references_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.search_references_id_seq OWNED BY public.search_references.id;


--
-- Name: section_notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.section_notes (
    id integer NOT NULL,
    section_id integer,
    content text
);


--
-- Name: section_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.section_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: section_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.section_notes_id_seq OWNED BY public.section_notes.id;


--
-- Name: sections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sections (
    id integer NOT NULL,
    "position" integer,
    numeral character varying(255),
    title character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone
);


--
-- Name: sections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sections_id_seq OWNED BY public.sections.id;


--
-- Name: session_audits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.session_audits (
    id integer NOT NULL,
    user_id integer,
    uid text,
    name text,
    email text,
    action text,
    updated_at timestamp without time zone,
    created_at timestamp without time zone
);


--
-- Name: session_audits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.session_audits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: session_audits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.session_audits_id_seq OWNED BY public.session_audits.id;


--
-- Name: tariff_update_conformance_errors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tariff_update_conformance_errors (
    id integer NOT NULL,
    tariff_update_filename text NOT NULL,
    model_name text NOT NULL,
    model_primary_key text NOT NULL,
    model_values text,
    model_conformance_errors text
);


--
-- Name: tariff_update_conformance_errors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tariff_update_conformance_errors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tariff_update_conformance_errors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tariff_update_conformance_errors_id_seq OWNED BY public.tariff_update_conformance_errors.id;


--
-- Name: tariff_updates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tariff_updates (
    filename character varying(30) NOT NULL,
    update_type character varying(50),
    state character varying(1),
    issue_date date,
    updated_at timestamp without time zone,
    created_at timestamp without time zone,
    filesize integer,
    applied_at timestamp without time zone,
    last_error text,
    last_error_at timestamp without time zone,
    exception_backtrace text,
    exception_queries text,
    exception_class text
);


--
-- Name: transmission_comments_oplog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transmission_comments_oplog (
    comment_sid integer,
    language_id character varying(5),
    comment_text text,
    created_at timestamp without time zone,
    oid integer NOT NULL,
    operation character varying(1) DEFAULT 'C'::character varying,
    operation_date timestamp without time zone,
    status text,
    workbasket_id integer,
    workbasket_sequence_number integer
);


--
-- Name: transmission_comments; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.transmission_comments AS
 SELECT transmission_comments1.comment_sid,
    transmission_comments1.language_id,
    transmission_comments1.comment_text,
    transmission_comments1.oid,
    transmission_comments1.operation,
    transmission_comments1.operation_date,
    transmission_comments1.status,
    transmission_comments1.workbasket_id,
    transmission_comments1.workbasket_sequence_number
   FROM public.transmission_comments_oplog transmission_comments1
  WHERE ((transmission_comments1.oid IN ( SELECT max(transmission_comments2.oid) AS max
           FROM public.transmission_comments_oplog transmission_comments2
          WHERE ((transmission_comments1.comment_sid = transmission_comments2.comment_sid) AND ((transmission_comments1.language_id)::text = (transmission_comments2.language_id)::text)))) AND ((transmission_comments1.operation)::text <> 'D'::text));


--
-- Name: transmission_comments_oid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transmission_comments_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transmission_comments_oid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transmission_comments_oid_seq OWNED BY public.transmission_comments_oplog.oid;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    uid text,
    name text,
    email text,
    version integer,
    permissions text,
    remotely_signed_out boolean,
    updated_at timestamp without time zone,
    created_at timestamp without time zone,
    organisation_slug text,
    disabled boolean DEFAULT false,
    organisation_content_id text,
    approver_user boolean DEFAULT false
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: workbasket_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workbasket_items (
    id integer NOT NULL,
    workbasket_id integer,
    record_id integer,
    record_type text,
    status text,
    updated_at timestamp without time zone,
    created_at timestamp without time zone,
    original_data jsonb DEFAULT '{}'::jsonb,
    record_key text,
    new_data jsonb DEFAULT '{}'::jsonb,
    changed_values jsonb DEFAULT '{}'::jsonb,
    validation_errors jsonb DEFAULT '{}'::jsonb,
    row_id text
);


--
-- Name: workbasket_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workbasket_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workbasket_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workbasket_items_id_seq OWNED BY public.workbasket_items.id;


--
-- Name: workbaskets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workbaskets (
    id integer NOT NULL,
    title text,
    type text,
    status text,
    user_id integer,
    last_update_by_id integer,
    last_status_change_at timestamp without time zone,
    updated_at timestamp without time zone,
    created_at timestamp without time zone,
    operation_date timestamp without time zone,
    cross_checker_id integer,
    approver_id integer
);


--
-- Name: workbaskets_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workbaskets_events (
    id integer NOT NULL,
    workbasket_id integer,
    user_id integer,
    event_type text,
    description text,
    updated_at timestamp without time zone,
    created_at timestamp without time zone
);


--
-- Name: workbaskets_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workbaskets_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workbaskets_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workbaskets_events_id_seq OWNED BY public.workbaskets_events.id;


--
-- Name: workbaskets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workbaskets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workbaskets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workbaskets_id_seq OWNED BY public.workbaskets.id;


--
-- Name: xml_export_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.xml_export_files (
    id integer NOT NULL,
    state character varying(1),
    updated_at timestamp without time zone,
    created_at timestamp without time zone,
    xml_data text,
    issue_date timestamp without time zone,
    meta_data text,
    workbasket boolean DEFAULT true,
    validation_errors jsonb DEFAULT '{}'::jsonb,
    envelope_id integer,
    workbasket_selected integer,
    user_id integer
);


--
-- Name: xml_export_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.xml_export_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xml_export_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.xml_export_files_id_seq OWNED BY public.xml_export_files.id;


--
-- Name: additional_code_description_periods_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.additional_code_description_periods_oplog ALTER COLUMN oid SET DEFAULT nextval('public.additional_code_description_periods_oid_seq'::regclass);


--
-- Name: additional_code_descriptions_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.additional_code_descriptions_oplog ALTER COLUMN oid SET DEFAULT nextval('public.additional_code_descriptions_oid_seq'::regclass);


--
-- Name: additional_code_type_descriptions_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.additional_code_type_descriptions_oplog ALTER COLUMN oid SET DEFAULT nextval('public.additional_code_type_descriptions_oid_seq'::regclass);


--
-- Name: additional_code_type_measure_types_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.additional_code_type_measure_types_oplog ALTER COLUMN oid SET DEFAULT nextval('public.additional_code_type_measure_types_oid_seq'::regclass);


--
-- Name: additional_code_types_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.additional_code_types_oplog ALTER COLUMN oid SET DEFAULT nextval('public.additional_code_types_oid_seq'::regclass);


--
-- Name: additional_codes_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.additional_codes_oplog ALTER COLUMN oid SET DEFAULT nextval('public.additional_codes_oid_seq'::regclass);


--
-- Name: audits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audits ALTER COLUMN id SET DEFAULT nextval('public.audits_id_seq'::regclass);


--
-- Name: base_regulations_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.base_regulations_oplog ALTER COLUMN oid SET DEFAULT nextval('public.base_regulations_oid_seq'::regclass);


--
-- Name: bulk_edit_of_additional_codes_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bulk_edit_of_additional_codes_settings ALTER COLUMN id SET DEFAULT nextval('public.bulk_edit_of_additional_codes_settings_id_seq'::regclass);


--
-- Name: bulk_edit_of_measures_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bulk_edit_of_measures_settings ALTER COLUMN id SET DEFAULT nextval('public.bulk_edit_of_measures_settings_id_seq'::regclass);


--
-- Name: bulk_edit_of_quotas_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bulk_edit_of_quotas_settings ALTER COLUMN id SET DEFAULT nextval('public.bulk_edit_of_quotas_settings_id_seq'::regclass);


--
-- Name: certificate_description_periods_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificate_description_periods_oplog ALTER COLUMN oid SET DEFAULT nextval('public.certificate_description_periods_oid_seq'::regclass);


--
-- Name: certificate_descriptions_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificate_descriptions_oplog ALTER COLUMN oid SET DEFAULT nextval('public.certificate_descriptions_oid_seq'::regclass);


--
-- Name: certificate_type_descriptions_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificate_type_descriptions_oplog ALTER COLUMN oid SET DEFAULT nextval('public.certificate_type_descriptions_oid_seq'::regclass);


--
-- Name: certificate_types_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificate_types_oplog ALTER COLUMN oid SET DEFAULT nextval('public.certificate_types_oid_seq'::regclass);


--
-- Name: certificates_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificates_oplog ALTER COLUMN oid SET DEFAULT nextval('public.certificates_oid_seq'::regclass);


--
-- Name: chapter_notes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapter_notes ALTER COLUMN id SET DEFAULT nextval('public.chapter_notes_id_seq'::regclass);


--
-- Name: chief_duty_expression id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chief_duty_expression ALTER COLUMN id SET DEFAULT nextval('public.chief_duty_expression_id_seq'::regclass);


--
-- Name: chief_measure_type_footnote id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chief_measure_type_footnote ALTER COLUMN id SET DEFAULT nextval('public.chief_measure_type_footnote_id_seq'::regclass);


--
-- Name: chief_measurement_unit id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chief_measurement_unit ALTER COLUMN id SET DEFAULT nextval('public.chief_measurement_unit_id_seq'::regclass);


--
-- Name: complete_abrogation_regulations_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.complete_abrogation_regulations_oplog ALTER COLUMN oid SET DEFAULT nextval('public.complete_abrogation_regulations_oid_seq'::regclass);


--
-- Name: create_additional_code_workbasket_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.create_additional_code_workbasket_settings ALTER COLUMN id SET DEFAULT nextval('public.create_additional_code_workbasket_settings_id_seq'::regclass);


--
-- Name: create_certificates_workbasket_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.create_certificates_workbasket_settings ALTER COLUMN id SET DEFAULT nextval('public.create_certificates_workbasket_settings_id_seq'::regclass);


--
-- Name: create_footnotes_workbasket_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.create_footnotes_workbasket_settings ALTER COLUMN id SET DEFAULT nextval('public.create_footnotes_workbasket_settings_id_seq'::regclass);


--
-- Name: create_geographical_area_workbasket_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.create_geographical_area_workbasket_settings ALTER COLUMN id SET DEFAULT nextval('public.create_geographical_area_workbasket_settings_id_seq'::regclass);


--
-- Name: create_measures_workbasket_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.create_measures_workbasket_settings ALTER COLUMN id SET DEFAULT nextval('public.create_measures_workbasket_settings_id_seq'::regclass);


--
-- Name: create_nomenclature_workbasket_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.create_nomenclature_workbasket_settings ALTER COLUMN id SET DEFAULT nextval('public.create_nomenclature_workbasket_settings_id_seq'::regclass);


--
-- Name: create_quota_association_workbasket_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.create_quota_association_workbasket_settings ALTER COLUMN id SET DEFAULT nextval('public.create_quota_association_workbasket_settings_id_seq'::regclass);


--
-- Name: create_quota_blocking_period_workbasket_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.create_quota_blocking_period_workbasket_settings ALTER COLUMN id SET DEFAULT nextval('public.create_quota_blocking_period_workbasket_settings_id_seq'::regclass);


--
-- Name: create_quota_suspension_workbasket_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.create_quota_suspension_workbasket_settings ALTER COLUMN id SET DEFAULT nextval('public.create_quota_suspension_workbasket_settings_id_seq'::regclass);


--
-- Name: create_quota_workbasket_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.create_quota_workbasket_settings ALTER COLUMN id SET DEFAULT nextval('public.create_quota_workbasket_settings_id_seq'::regclass);


--
-- Name: create_regulation_workbasket_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.create_regulation_workbasket_settings ALTER COLUMN id SET DEFAULT nextval('public.create_regulation_workbasket_settings_id_seq'::regclass);


--
-- Name: db_rollbacks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.db_rollbacks ALTER COLUMN id SET DEFAULT nextval('public.db_rollbacks_id_seq'::regclass);


--
-- Name: delete_quota_association_workbasket_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delete_quota_association_workbasket_settings ALTER COLUMN id SET DEFAULT nextval('public.delete_quota_association_workbasket_settings_id_seq'::regclass);


--
-- Name: delete_quota_blocking_period_workbasket_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delete_quota_blocking_period_workbasket_settings ALTER COLUMN id SET DEFAULT nextval('public.delete_quota_blocking_period_workbasket_settings_id_seq'::regclass);


--
-- Name: delete_quota_suspension_workbasket_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delete_quota_suspension_workbasket_settings ALTER COLUMN id SET DEFAULT nextval('public.delete_quota_suspension_workbasket_settings_id_seq'::regclass);


--
-- Name: duty_expression_descriptions_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.duty_expression_descriptions_oplog ALTER COLUMN oid SET DEFAULT nextval('public.duty_expression_descriptions_oid_seq'::regclass);


--
-- Name: duty_expressions_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.duty_expressions_oplog ALTER COLUMN oid SET DEFAULT nextval('public.duty_expressions_oid_seq'::regclass);


--
-- Name: edit_certificates_workbasket_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.edit_certificates_workbasket_settings ALTER COLUMN id SET DEFAULT nextval('public.edit_certificates_workbasket_settings_id_seq'::regclass);


--
-- Name: edit_footnotes_workbasket_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.edit_footnotes_workbasket_settings ALTER COLUMN id SET DEFAULT nextval('public.edit_footnotes_workbasket_settings_id_seq'::regclass);


--
-- Name: edit_geographical_areas_workbasket_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.edit_geographical_areas_workbasket_settings ALTER COLUMN id SET DEFAULT nextval('public.edit_geographical_areas_workbasket_settings_id_seq'::regclass);


--
-- Name: edit_nomenclature_workbasket_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.edit_nomenclature_workbasket_settings ALTER COLUMN id SET DEFAULT nextval('public.edit_nomenclature_workbasket_settings_id_seq'::regclass);


--
-- Name: edit_quota_blocking_period_workbasket_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.edit_quota_blocking_period_workbasket_settings ALTER COLUMN id SET DEFAULT nextval('public.edit_quota_blocking_period_workbasket_settings_id_seq'::regclass);


--
-- Name: edit_quota_suspension_workbasket_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.edit_quota_suspension_workbasket_settings ALTER COLUMN id SET DEFAULT nextval('public.edit_quota_suspension_workbasket_settings_id_seq'::regclass);


--
-- Name: edit_regulation_workbasket_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.edit_regulation_workbasket_settings ALTER COLUMN id SET DEFAULT nextval('public.edit_regulation_workbasket_settings_id_seq'::regclass);


--
-- Name: explicit_abrogation_regulations_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.explicit_abrogation_regulations_oplog ALTER COLUMN oid SET DEFAULT nextval('public.explicit_abrogation_regulations_oid_seq'::regclass);


--
-- Name: export_refund_nomenclature_description_periods_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.export_refund_nomenclature_description_periods_oplog ALTER COLUMN oid SET DEFAULT nextval('public.export_refund_nomenclature_description_periods_oid_seq'::regclass);


--
-- Name: export_refund_nomenclature_descriptions_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.export_refund_nomenclature_descriptions_oplog ALTER COLUMN oid SET DEFAULT nextval('public.export_refund_nomenclature_descriptions_oid_seq'::regclass);


--
-- Name: export_refund_nomenclature_indents_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.export_refund_nomenclature_indents_oplog ALTER COLUMN oid SET DEFAULT nextval('public.export_refund_nomenclature_indents_oid_seq'::regclass);


--
-- Name: export_refund_nomenclatures_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.export_refund_nomenclatures_oplog ALTER COLUMN oid SET DEFAULT nextval('public.export_refund_nomenclatures_oid_seq'::regclass);


--
-- Name: footnote_association_additional_codes_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.footnote_association_additional_codes_oplog ALTER COLUMN oid SET DEFAULT nextval('public.footnote_association_additional_codes_oid_seq'::regclass);


--
-- Name: footnote_association_erns_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.footnote_association_erns_oplog ALTER COLUMN oid SET DEFAULT nextval('public.footnote_association_erns_oid_seq'::regclass);


--
-- Name: footnote_association_goods_nomenclatures_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.footnote_association_goods_nomenclatures_oplog ALTER COLUMN oid SET DEFAULT nextval('public.footnote_association_goods_nomenclatures_oid_seq'::regclass);


--
-- Name: footnote_association_measures_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.footnote_association_measures_oplog ALTER COLUMN oid SET DEFAULT nextval('public.footnote_association_measures_oid_seq'::regclass);


--
-- Name: footnote_association_meursing_headings_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.footnote_association_meursing_headings_oplog ALTER COLUMN oid SET DEFAULT nextval('public.footnote_association_meursing_headings_oid_seq'::regclass);


--
-- Name: footnote_description_periods_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.footnote_description_periods_oplog ALTER COLUMN oid SET DEFAULT nextval('public.footnote_description_periods_oid_seq'::regclass);


--
-- Name: footnote_descriptions_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.footnote_descriptions_oplog ALTER COLUMN oid SET DEFAULT nextval('public.footnote_descriptions_oid_seq'::regclass);


--
-- Name: footnote_type_descriptions_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.footnote_type_descriptions_oplog ALTER COLUMN oid SET DEFAULT nextval('public.footnote_type_descriptions_oid_seq'::regclass);


--
-- Name: footnote_types_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.footnote_types_oplog ALTER COLUMN oid SET DEFAULT nextval('public.footnote_types_oid_seq'::regclass);


--
-- Name: footnotes_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.footnotes_oplog ALTER COLUMN oid SET DEFAULT nextval('public.footnotes_oid_seq'::regclass);


--
-- Name: fts_regulation_actions_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fts_regulation_actions_oplog ALTER COLUMN oid SET DEFAULT nextval('public.fts_regulation_actions_oid_seq'::regclass);


--
-- Name: full_temporary_stop_regulations_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.full_temporary_stop_regulations_oplog ALTER COLUMN oid SET DEFAULT nextval('public.full_temporary_stop_regulations_oid_seq'::regclass);


--
-- Name: geographical_area_description_periods_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geographical_area_description_periods_oplog ALTER COLUMN oid SET DEFAULT nextval('public.geographical_area_description_periods_oid_seq'::regclass);


--
-- Name: geographical_area_descriptions_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geographical_area_descriptions_oplog ALTER COLUMN oid SET DEFAULT nextval('public.geographical_area_descriptions_oid_seq'::regclass);


--
-- Name: geographical_area_memberships_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geographical_area_memberships_oplog ALTER COLUMN oid SET DEFAULT nextval('public.geographical_area_memberships_oid_seq'::regclass);


--
-- Name: geographical_areas_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geographical_areas_oplog ALTER COLUMN oid SET DEFAULT nextval('public.geographical_areas_oid_seq'::regclass);


--
-- Name: goods_nomenclature_description_periods_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goods_nomenclature_description_periods_oplog ALTER COLUMN oid SET DEFAULT nextval('public.goods_nomenclature_description_periods_oid_seq'::regclass);


--
-- Name: goods_nomenclature_descriptions_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goods_nomenclature_descriptions_oplog ALTER COLUMN oid SET DEFAULT nextval('public.goods_nomenclature_descriptions_oid_seq'::regclass);


--
-- Name: goods_nomenclature_group_descriptions_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goods_nomenclature_group_descriptions_oplog ALTER COLUMN oid SET DEFAULT nextval('public.goods_nomenclature_group_descriptions_oid_seq'::regclass);


--
-- Name: goods_nomenclature_groups_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goods_nomenclature_groups_oplog ALTER COLUMN oid SET DEFAULT nextval('public.goods_nomenclature_groups_oid_seq'::regclass);


--
-- Name: goods_nomenclature_indents_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goods_nomenclature_indents_oplog ALTER COLUMN oid SET DEFAULT nextval('public.goods_nomenclature_indents_oid_seq'::regclass);


--
-- Name: goods_nomenclature_origins_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goods_nomenclature_origins_oplog ALTER COLUMN oid SET DEFAULT nextval('public.goods_nomenclature_origins_oid_seq'::regclass);


--
-- Name: goods_nomenclature_successors_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goods_nomenclature_successors_oplog ALTER COLUMN oid SET DEFAULT nextval('public.goods_nomenclature_successors_oid_seq'::regclass);


--
-- Name: goods_nomenclatures_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goods_nomenclatures_oplog ALTER COLUMN oid SET DEFAULT nextval('public.goods_nomenclatures_oid_seq'::regclass);


--
-- Name: language_descriptions_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.language_descriptions_oplog ALTER COLUMN oid SET DEFAULT nextval('public.language_descriptions_oid_seq'::regclass);


--
-- Name: languages_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.languages_oplog ALTER COLUMN oid SET DEFAULT nextval('public.languages_oid_seq'::regclass);


--
-- Name: measure_action_descriptions_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measure_action_descriptions_oplog ALTER COLUMN oid SET DEFAULT nextval('public.measure_action_descriptions_oid_seq'::regclass);


--
-- Name: measure_actions_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measure_actions_oplog ALTER COLUMN oid SET DEFAULT nextval('public.measure_actions_oid_seq'::regclass);


--
-- Name: measure_components_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measure_components_oplog ALTER COLUMN oid SET DEFAULT nextval('public.measure_components_oid_seq'::regclass);


--
-- Name: measure_condition_code_descriptions_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measure_condition_code_descriptions_oplog ALTER COLUMN oid SET DEFAULT nextval('public.measure_condition_code_descriptions_oid_seq'::regclass);


--
-- Name: measure_condition_codes_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measure_condition_codes_oplog ALTER COLUMN oid SET DEFAULT nextval('public.measure_condition_codes_oid_seq'::regclass);


--
-- Name: measure_condition_components_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measure_condition_components_oplog ALTER COLUMN oid SET DEFAULT nextval('public.measure_condition_components_oid_seq'::regclass);


--
-- Name: measure_conditions_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measure_conditions_oplog ALTER COLUMN oid SET DEFAULT nextval('public.measure_conditions_oid_seq'::regclass);


--
-- Name: measure_excluded_geographical_areas_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measure_excluded_geographical_areas_oplog ALTER COLUMN oid SET DEFAULT nextval('public.measure_excluded_geographical_areas_oid_seq'::regclass);


--
-- Name: measure_partial_temporary_stops_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measure_partial_temporary_stops_oplog ALTER COLUMN oid SET DEFAULT nextval('public.measure_partial_temporary_stops_oid_seq'::regclass);


--
-- Name: measure_type_descriptions_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measure_type_descriptions_oplog ALTER COLUMN oid SET DEFAULT nextval('public.measure_type_descriptions_oid_seq'::regclass);


--
-- Name: measure_type_series_descriptions_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measure_type_series_descriptions_oplog ALTER COLUMN oid SET DEFAULT nextval('public.measure_type_series_descriptions_oid_seq'::regclass);


--
-- Name: measure_type_series_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measure_type_series_oplog ALTER COLUMN oid SET DEFAULT nextval('public.measure_type_series_oid_seq'::regclass);


--
-- Name: measure_types_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measure_types_oplog ALTER COLUMN oid SET DEFAULT nextval('public.measure_types_oid_seq'::regclass);


--
-- Name: measurement_unit_abbreviations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measurement_unit_abbreviations ALTER COLUMN id SET DEFAULT nextval('public.measurement_unit_abbreviations_id_seq'::regclass);


--
-- Name: measurement_unit_descriptions_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measurement_unit_descriptions_oplog ALTER COLUMN oid SET DEFAULT nextval('public.measurement_unit_descriptions_oid_seq'::regclass);


--
-- Name: measurement_unit_qualifier_descriptions_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measurement_unit_qualifier_descriptions_oplog ALTER COLUMN oid SET DEFAULT nextval('public.measurement_unit_qualifier_descriptions_oid_seq'::regclass);


--
-- Name: measurement_unit_qualifiers_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measurement_unit_qualifiers_oplog ALTER COLUMN oid SET DEFAULT nextval('public.measurement_unit_qualifiers_oid_seq'::regclass);


--
-- Name: measurement_units_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measurement_units_oplog ALTER COLUMN oid SET DEFAULT nextval('public.measurement_units_oid_seq'::regclass);


--
-- Name: measurements_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measurements_oplog ALTER COLUMN oid SET DEFAULT nextval('public.measurements_oid_seq'::regclass);


--
-- Name: measures_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measures_oplog ALTER COLUMN oid SET DEFAULT nextval('public.measures_oid_seq'::regclass);


--
-- Name: meursing_additional_codes_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meursing_additional_codes_oplog ALTER COLUMN oid SET DEFAULT nextval('public.meursing_additional_codes_oid_seq'::regclass);


--
-- Name: meursing_heading_texts_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meursing_heading_texts_oplog ALTER COLUMN oid SET DEFAULT nextval('public.meursing_heading_texts_oid_seq'::regclass);


--
-- Name: meursing_headings_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meursing_headings_oplog ALTER COLUMN oid SET DEFAULT nextval('public.meursing_headings_oid_seq'::regclass);


--
-- Name: meursing_subheadings_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meursing_subheadings_oplog ALTER COLUMN oid SET DEFAULT nextval('public.meursing_subheadings_oid_seq'::regclass);


--
-- Name: meursing_table_cell_components_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meursing_table_cell_components_oplog ALTER COLUMN oid SET DEFAULT nextval('public.meursing_table_cell_components_oid_seq'::regclass);


--
-- Name: meursing_table_plans_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meursing_table_plans_oplog ALTER COLUMN oid SET DEFAULT nextval('public.meursing_table_plans_oid_seq'::regclass);


--
-- Name: modification_regulations_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.modification_regulations_oplog ALTER COLUMN oid SET DEFAULT nextval('public.modification_regulations_oid_seq'::regclass);


--
-- Name: monetary_exchange_periods_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.monetary_exchange_periods_oplog ALTER COLUMN oid SET DEFAULT nextval('public.monetary_exchange_periods_oid_seq'::regclass);


--
-- Name: monetary_exchange_rates_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.monetary_exchange_rates_oplog ALTER COLUMN oid SET DEFAULT nextval('public.monetary_exchange_rates_oid_seq'::regclass);


--
-- Name: monetary_unit_descriptions_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.monetary_unit_descriptions_oplog ALTER COLUMN oid SET DEFAULT nextval('public.monetary_unit_descriptions_oid_seq'::regclass);


--
-- Name: monetary_units_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.monetary_units_oplog ALTER COLUMN oid SET DEFAULT nextval('public.monetary_units_oid_seq'::regclass);


--
-- Name: nomenclature_group_memberships_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nomenclature_group_memberships_oplog ALTER COLUMN oid SET DEFAULT nextval('public.nomenclature_group_memberships_oid_seq'::regclass);


--
-- Name: prorogation_regulation_actions_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prorogation_regulation_actions_oplog ALTER COLUMN oid SET DEFAULT nextval('public.prorogation_regulation_actions_oid_seq'::regclass);


--
-- Name: prorogation_regulations_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prorogation_regulations_oplog ALTER COLUMN oid SET DEFAULT nextval('public.prorogation_regulations_oid_seq'::regclass);


--
-- Name: publication_sigles_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publication_sigles_oplog ALTER COLUMN oid SET DEFAULT nextval('public.publication_sigles_oplog_oid_seq'::regclass);


--
-- Name: quota_associations_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quota_associations_oplog ALTER COLUMN oid SET DEFAULT nextval('public.quota_associations_oid_seq'::regclass);


--
-- Name: quota_balance_events_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quota_balance_events_oplog ALTER COLUMN oid SET DEFAULT nextval('public.quota_balance_events_oid_seq'::regclass);


--
-- Name: quota_blocking_periods_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quota_blocking_periods_oplog ALTER COLUMN oid SET DEFAULT nextval('public.quota_blocking_periods_oid_seq'::regclass);


--
-- Name: quota_critical_events_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quota_critical_events_oplog ALTER COLUMN oid SET DEFAULT nextval('public.quota_critical_events_oid_seq'::regclass);


--
-- Name: quota_definitions_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quota_definitions_oplog ALTER COLUMN oid SET DEFAULT nextval('public.quota_definitions_oid_seq'::regclass);


--
-- Name: quota_exhaustion_events_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quota_exhaustion_events_oplog ALTER COLUMN oid SET DEFAULT nextval('public.quota_exhaustion_events_oid_seq'::regclass);


--
-- Name: quota_order_number_origin_exclusions_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quota_order_number_origin_exclusions_oplog ALTER COLUMN oid SET DEFAULT nextval('public.quota_order_number_origin_exclusions_oid_seq'::regclass);


--
-- Name: quota_order_number_origins_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quota_order_number_origins_oplog ALTER COLUMN oid SET DEFAULT nextval('public.quota_order_number_origins_oid_seq'::regclass);


--
-- Name: quota_order_numbers_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quota_order_numbers_oplog ALTER COLUMN oid SET DEFAULT nextval('public.quota_order_numbers_oid_seq'::regclass);


--
-- Name: quota_reopening_events_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quota_reopening_events_oplog ALTER COLUMN oid SET DEFAULT nextval('public.quota_reopening_events_oid_seq'::regclass);


--
-- Name: quota_suspension_periods_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quota_suspension_periods_oplog ALTER COLUMN oid SET DEFAULT nextval('public.quota_suspension_periods_oid_seq'::regclass);


--
-- Name: quota_unblocking_events_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quota_unblocking_events_oplog ALTER COLUMN oid SET DEFAULT nextval('public.quota_unblocking_events_oid_seq'::regclass);


--
-- Name: quota_unsuspension_events_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quota_unsuspension_events_oplog ALTER COLUMN oid SET DEFAULT nextval('public.quota_unsuspension_events_oid_seq'::regclass);


--
-- Name: regulation_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regulation_documents ALTER COLUMN id SET DEFAULT nextval('public.regulation_documents_id_seq'::regclass);


--
-- Name: regulation_group_descriptions_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regulation_group_descriptions_oplog ALTER COLUMN oid SET DEFAULT nextval('public.regulation_group_descriptions_oid_seq'::regclass);


--
-- Name: regulation_groups_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regulation_groups_oplog ALTER COLUMN oid SET DEFAULT nextval('public.regulation_groups_oid_seq'::regclass);


--
-- Name: regulation_replacements_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regulation_replacements_oplog ALTER COLUMN oid SET DEFAULT nextval('public.regulation_replacements_oid_seq'::regclass);


--
-- Name: regulation_role_type_descriptions_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regulation_role_type_descriptions_oplog ALTER COLUMN oid SET DEFAULT nextval('public.regulation_role_type_descriptions_oid_seq'::regclass);


--
-- Name: regulation_role_types_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regulation_role_types_oplog ALTER COLUMN oid SET DEFAULT nextval('public.regulation_role_types_oid_seq'::regclass);


--
-- Name: rollbacks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rollbacks ALTER COLUMN id SET DEFAULT nextval('public.rollbacks_id_seq'::regclass);


--
-- Name: search_references id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.search_references ALTER COLUMN id SET DEFAULT nextval('public.search_references_id_seq'::regclass);


--
-- Name: section_notes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.section_notes ALTER COLUMN id SET DEFAULT nextval('public.section_notes_id_seq'::regclass);


--
-- Name: sections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections ALTER COLUMN id SET DEFAULT nextval('public.sections_id_seq'::regclass);


--
-- Name: session_audits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_audits ALTER COLUMN id SET DEFAULT nextval('public.session_audits_id_seq'::regclass);


--
-- Name: tariff_update_conformance_errors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tariff_update_conformance_errors ALTER COLUMN id SET DEFAULT nextval('public.tariff_update_conformance_errors_id_seq'::regclass);


--
-- Name: transmission_comments_oplog oid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transmission_comments_oplog ALTER COLUMN oid SET DEFAULT nextval('public.transmission_comments_oid_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: workbasket_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workbasket_items ALTER COLUMN id SET DEFAULT nextval('public.workbasket_items_id_seq'::regclass);


--
-- Name: workbaskets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workbaskets ALTER COLUMN id SET DEFAULT nextval('public.workbaskets_id_seq'::regclass);


--
-- Name: workbaskets_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workbaskets_events ALTER COLUMN id SET DEFAULT nextval('public.workbaskets_events_id_seq'::regclass);


--
-- Name: xml_export_files id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.xml_export_files ALTER COLUMN id SET DEFAULT nextval('public.xml_export_files_id_seq'::regclass);


--
-- Name: additional_code_description_periods_oplog additional_code_description_periods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.additional_code_description_periods_oplog
    ADD CONSTRAINT additional_code_description_periods_pkey PRIMARY KEY (oid);


--
-- Name: additional_code_descriptions_oplog additional_code_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.additional_code_descriptions_oplog
    ADD CONSTRAINT additional_code_descriptions_pkey PRIMARY KEY (oid);


--
-- Name: additional_code_type_descriptions_oplog additional_code_type_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.additional_code_type_descriptions_oplog
    ADD CONSTRAINT additional_code_type_descriptions_pkey PRIMARY KEY (oid);


--
-- Name: additional_code_type_measure_types_oplog additional_code_type_measure_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.additional_code_type_measure_types_oplog
    ADD CONSTRAINT additional_code_type_measure_types_pkey PRIMARY KEY (oid);


--
-- Name: additional_code_types_oplog additional_code_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.additional_code_types_oplog
    ADD CONSTRAINT additional_code_types_pkey PRIMARY KEY (oid);


--
-- Name: additional_codes_oplog additional_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.additional_codes_oplog
    ADD CONSTRAINT additional_codes_pkey PRIMARY KEY (oid);


--
-- Name: audits audits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audits
    ADD CONSTRAINT audits_pkey PRIMARY KEY (id);


--
-- Name: base_regulations_oplog base_regulations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.base_regulations_oplog
    ADD CONSTRAINT base_regulations_pkey PRIMARY KEY (oid);


--
-- Name: bulk_edit_of_additional_codes_settings bulk_edit_of_additional_codes_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bulk_edit_of_additional_codes_settings
    ADD CONSTRAINT bulk_edit_of_additional_codes_settings_pkey PRIMARY KEY (id);


--
-- Name: bulk_edit_of_measures_settings bulk_edit_of_measures_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bulk_edit_of_measures_settings
    ADD CONSTRAINT bulk_edit_of_measures_settings_pkey PRIMARY KEY (id);


--
-- Name: bulk_edit_of_quotas_settings bulk_edit_of_quotas_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bulk_edit_of_quotas_settings
    ADD CONSTRAINT bulk_edit_of_quotas_settings_pkey PRIMARY KEY (id);


--
-- Name: certificate_description_periods_oplog certificate_description_periods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificate_description_periods_oplog
    ADD CONSTRAINT certificate_description_periods_pkey PRIMARY KEY (oid);


--
-- Name: certificate_descriptions_oplog certificate_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificate_descriptions_oplog
    ADD CONSTRAINT certificate_descriptions_pkey PRIMARY KEY (oid);


--
-- Name: certificate_type_descriptions_oplog certificate_type_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificate_type_descriptions_oplog
    ADD CONSTRAINT certificate_type_descriptions_pkey PRIMARY KEY (oid);


--
-- Name: certificate_types_oplog certificate_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificate_types_oplog
    ADD CONSTRAINT certificate_types_pkey PRIMARY KEY (oid);


--
-- Name: certificates_oplog certificates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificates_oplog
    ADD CONSTRAINT certificates_pkey PRIMARY KEY (oid);


--
-- Name: chapter_notes chapter_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chapter_notes
    ADD CONSTRAINT chapter_notes_pkey PRIMARY KEY (id);


--
-- Name: chief_duty_expression chief_duty_expression_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chief_duty_expression
    ADD CONSTRAINT chief_duty_expression_pkey PRIMARY KEY (id);


--
-- Name: chief_measure_type_footnote chief_measure_type_footnote_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chief_measure_type_footnote
    ADD CONSTRAINT chief_measure_type_footnote_pkey PRIMARY KEY (id);


--
-- Name: chief_measurement_unit chief_measurement_unit_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chief_measurement_unit
    ADD CONSTRAINT chief_measurement_unit_pkey PRIMARY KEY (id);


--
-- Name: complete_abrogation_regulations_oplog complete_abrogation_regulations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.complete_abrogation_regulations_oplog
    ADD CONSTRAINT complete_abrogation_regulations_pkey PRIMARY KEY (oid);


--
-- Name: create_additional_code_workbasket_settings create_additional_code_workbasket_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.create_additional_code_workbasket_settings
    ADD CONSTRAINT create_additional_code_workbasket_settings_pkey PRIMARY KEY (id);


--
-- Name: create_certificates_workbasket_settings create_certificates_workbasket_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.create_certificates_workbasket_settings
    ADD CONSTRAINT create_certificates_workbasket_settings_pkey PRIMARY KEY (id);


--
-- Name: create_footnotes_workbasket_settings create_footnotes_workbasket_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.create_footnotes_workbasket_settings
    ADD CONSTRAINT create_footnotes_workbasket_settings_pkey PRIMARY KEY (id);


--
-- Name: create_geographical_area_workbasket_settings create_geographical_area_workbasket_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.create_geographical_area_workbasket_settings
    ADD CONSTRAINT create_geographical_area_workbasket_settings_pkey PRIMARY KEY (id);


--
-- Name: create_measures_workbasket_settings create_measures_workbasket_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.create_measures_workbasket_settings
    ADD CONSTRAINT create_measures_workbasket_settings_pkey PRIMARY KEY (id);


--
-- Name: create_nomenclature_workbasket_settings create_nomenclature_workbasket_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.create_nomenclature_workbasket_settings
    ADD CONSTRAINT create_nomenclature_workbasket_settings_pkey PRIMARY KEY (id);


--
-- Name: create_quota_association_workbasket_settings create_quota_association_workbasket_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.create_quota_association_workbasket_settings
    ADD CONSTRAINT create_quota_association_workbasket_settings_pkey PRIMARY KEY (id);


--
-- Name: create_quota_blocking_period_workbasket_settings create_quota_blocking_period_workbasket_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.create_quota_blocking_period_workbasket_settings
    ADD CONSTRAINT create_quota_blocking_period_workbasket_settings_pkey PRIMARY KEY (id);


--
-- Name: create_quota_suspension_workbasket_settings create_quota_suspension_workbasket_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.create_quota_suspension_workbasket_settings
    ADD CONSTRAINT create_quota_suspension_workbasket_settings_pkey PRIMARY KEY (id);


--
-- Name: create_quota_workbasket_settings create_quota_workbasket_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.create_quota_workbasket_settings
    ADD CONSTRAINT create_quota_workbasket_settings_pkey PRIMARY KEY (id);


--
-- Name: create_regulation_workbasket_settings create_regulation_workbasket_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.create_regulation_workbasket_settings
    ADD CONSTRAINT create_regulation_workbasket_settings_pkey PRIMARY KEY (id);


--
-- Name: data_migrations data_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_migrations
    ADD CONSTRAINT data_migrations_pkey PRIMARY KEY (filename);


--
-- Name: db_rollbacks db_rollbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.db_rollbacks
    ADD CONSTRAINT db_rollbacks_pkey PRIMARY KEY (id);


--
-- Name: delete_quota_association_workbasket_settings delete_quota_association_workbasket_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delete_quota_association_workbasket_settings
    ADD CONSTRAINT delete_quota_association_workbasket_settings_pkey PRIMARY KEY (id);


--
-- Name: delete_quota_blocking_period_workbasket_settings delete_quota_blocking_period_workbasket_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delete_quota_blocking_period_workbasket_settings
    ADD CONSTRAINT delete_quota_blocking_period_workbasket_settings_pkey PRIMARY KEY (id);


--
-- Name: delete_quota_suspension_workbasket_settings delete_quota_suspension_workbasket_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delete_quota_suspension_workbasket_settings
    ADD CONSTRAINT delete_quota_suspension_workbasket_settings_pkey PRIMARY KEY (id);


--
-- Name: duty_expression_descriptions_oplog duty_expression_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.duty_expression_descriptions_oplog
    ADD CONSTRAINT duty_expression_descriptions_pkey PRIMARY KEY (oid);


--
-- Name: duty_expressions_oplog duty_expressions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.duty_expressions_oplog
    ADD CONSTRAINT duty_expressions_pkey PRIMARY KEY (oid);


--
-- Name: edit_certificates_workbasket_settings edit_certificates_workbasket_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.edit_certificates_workbasket_settings
    ADD CONSTRAINT edit_certificates_workbasket_settings_pkey PRIMARY KEY (id);


--
-- Name: edit_footnotes_workbasket_settings edit_footnotes_workbasket_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.edit_footnotes_workbasket_settings
    ADD CONSTRAINT edit_footnotes_workbasket_settings_pkey PRIMARY KEY (id);


--
-- Name: edit_geographical_areas_workbasket_settings edit_geographical_areas_workbasket_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.edit_geographical_areas_workbasket_settings
    ADD CONSTRAINT edit_geographical_areas_workbasket_settings_pkey PRIMARY KEY (id);


--
-- Name: edit_nomenclature_workbasket_settings edit_nomenclature_workbasket_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.edit_nomenclature_workbasket_settings
    ADD CONSTRAINT edit_nomenclature_workbasket_settings_pkey PRIMARY KEY (id);


--
-- Name: edit_quota_blocking_period_workbasket_settings edit_quota_blocking_period_workbasket_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.edit_quota_blocking_period_workbasket_settings
    ADD CONSTRAINT edit_quota_blocking_period_workbasket_settings_pkey PRIMARY KEY (id);


--
-- Name: edit_quota_suspension_workbasket_settings edit_quota_suspension_workbasket_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.edit_quota_suspension_workbasket_settings
    ADD CONSTRAINT edit_quota_suspension_workbasket_settings_pkey PRIMARY KEY (id);


--
-- Name: edit_regulation_workbasket_settings edit_regulation_workbasket_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.edit_regulation_workbasket_settings
    ADD CONSTRAINT edit_regulation_workbasket_settings_pkey PRIMARY KEY (id);


--
-- Name: explicit_abrogation_regulations_oplog explicit_abrogation_regulations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.explicit_abrogation_regulations_oplog
    ADD CONSTRAINT explicit_abrogation_regulations_pkey PRIMARY KEY (oid);


--
-- Name: export_refund_nomenclature_description_periods_oplog export_refund_nomenclature_description_periods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.export_refund_nomenclature_description_periods_oplog
    ADD CONSTRAINT export_refund_nomenclature_description_periods_pkey PRIMARY KEY (oid);


--
-- Name: export_refund_nomenclature_descriptions_oplog export_refund_nomenclature_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.export_refund_nomenclature_descriptions_oplog
    ADD CONSTRAINT export_refund_nomenclature_descriptions_pkey PRIMARY KEY (oid);


--
-- Name: export_refund_nomenclature_indents_oplog export_refund_nomenclature_indents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.export_refund_nomenclature_indents_oplog
    ADD CONSTRAINT export_refund_nomenclature_indents_pkey PRIMARY KEY (oid);


--
-- Name: export_refund_nomenclatures_oplog export_refund_nomenclatures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.export_refund_nomenclatures_oplog
    ADD CONSTRAINT export_refund_nomenclatures_pkey PRIMARY KEY (oid);


--
-- Name: footnote_association_additional_codes_oplog footnote_association_additional_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.footnote_association_additional_codes_oplog
    ADD CONSTRAINT footnote_association_additional_codes_pkey PRIMARY KEY (oid);


--
-- Name: footnote_association_erns_oplog footnote_association_erns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.footnote_association_erns_oplog
    ADD CONSTRAINT footnote_association_erns_pkey PRIMARY KEY (oid);


--
-- Name: footnote_association_goods_nomenclatures_oplog footnote_association_goods_nomenclatures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.footnote_association_goods_nomenclatures_oplog
    ADD CONSTRAINT footnote_association_goods_nomenclatures_pkey PRIMARY KEY (oid);


--
-- Name: footnote_association_measures_oplog footnote_association_measures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.footnote_association_measures_oplog
    ADD CONSTRAINT footnote_association_measures_pkey PRIMARY KEY (oid);


--
-- Name: footnote_association_meursing_headings_oplog footnote_association_meursing_headings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.footnote_association_meursing_headings_oplog
    ADD CONSTRAINT footnote_association_meursing_headings_pkey PRIMARY KEY (oid);


--
-- Name: footnote_description_periods_oplog footnote_description_periods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.footnote_description_periods_oplog
    ADD CONSTRAINT footnote_description_periods_pkey PRIMARY KEY (oid);


--
-- Name: footnote_descriptions_oplog footnote_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.footnote_descriptions_oplog
    ADD CONSTRAINT footnote_descriptions_pkey PRIMARY KEY (oid);


--
-- Name: footnote_type_descriptions_oplog footnote_type_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.footnote_type_descriptions_oplog
    ADD CONSTRAINT footnote_type_descriptions_pkey PRIMARY KEY (oid);


--
-- Name: footnote_types_oplog footnote_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.footnote_types_oplog
    ADD CONSTRAINT footnote_types_pkey PRIMARY KEY (oid);


--
-- Name: footnotes_oplog footnotes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.footnotes_oplog
    ADD CONSTRAINT footnotes_pkey PRIMARY KEY (oid);


--
-- Name: fts_regulation_actions_oplog fts_regulation_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fts_regulation_actions_oplog
    ADD CONSTRAINT fts_regulation_actions_pkey PRIMARY KEY (oid);


--
-- Name: full_temporary_stop_regulations_oplog full_temporary_stop_regulations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.full_temporary_stop_regulations_oplog
    ADD CONSTRAINT full_temporary_stop_regulations_pkey PRIMARY KEY (oid);


--
-- Name: geographical_area_description_periods_oplog geographical_area_description_periods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geographical_area_description_periods_oplog
    ADD CONSTRAINT geographical_area_description_periods_pkey PRIMARY KEY (oid);


--
-- Name: geographical_area_descriptions_oplog geographical_area_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geographical_area_descriptions_oplog
    ADD CONSTRAINT geographical_area_descriptions_pkey PRIMARY KEY (oid);


--
-- Name: geographical_area_memberships_oplog geographical_area_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geographical_area_memberships_oplog
    ADD CONSTRAINT geographical_area_memberships_pkey PRIMARY KEY (oid);


--
-- Name: geographical_areas_oplog geographical_areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geographical_areas_oplog
    ADD CONSTRAINT geographical_areas_pkey PRIMARY KEY (oid);


--
-- Name: goods_nomenclature_description_periods_oplog goods_nomenclature_description_periods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goods_nomenclature_description_periods_oplog
    ADD CONSTRAINT goods_nomenclature_description_periods_pkey PRIMARY KEY (oid);


--
-- Name: goods_nomenclature_descriptions_oplog goods_nomenclature_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goods_nomenclature_descriptions_oplog
    ADD CONSTRAINT goods_nomenclature_descriptions_pkey PRIMARY KEY (oid);


--
-- Name: goods_nomenclature_group_descriptions_oplog goods_nomenclature_group_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goods_nomenclature_group_descriptions_oplog
    ADD CONSTRAINT goods_nomenclature_group_descriptions_pkey PRIMARY KEY (oid);


--
-- Name: goods_nomenclature_groups_oplog goods_nomenclature_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goods_nomenclature_groups_oplog
    ADD CONSTRAINT goods_nomenclature_groups_pkey PRIMARY KEY (oid);


--
-- Name: goods_nomenclature_indents_oplog goods_nomenclature_indents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goods_nomenclature_indents_oplog
    ADD CONSTRAINT goods_nomenclature_indents_pkey PRIMARY KEY (oid);


--
-- Name: goods_nomenclature_origins_oplog goods_nomenclature_origins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goods_nomenclature_origins_oplog
    ADD CONSTRAINT goods_nomenclature_origins_pkey PRIMARY KEY (oid);


--
-- Name: goods_nomenclature_successors_oplog goods_nomenclature_successors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goods_nomenclature_successors_oplog
    ADD CONSTRAINT goods_nomenclature_successors_pkey PRIMARY KEY (oid);


--
-- Name: goods_nomenclatures_oplog goods_nomenclatures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goods_nomenclatures_oplog
    ADD CONSTRAINT goods_nomenclatures_pkey PRIMARY KEY (oid);


--
-- Name: language_descriptions_oplog language_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.language_descriptions_oplog
    ADD CONSTRAINT language_descriptions_pkey PRIMARY KEY (oid);


--
-- Name: languages_oplog languages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.languages_oplog
    ADD CONSTRAINT languages_pkey PRIMARY KEY (oid);


--
-- Name: measure_action_descriptions_oplog measure_action_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measure_action_descriptions_oplog
    ADD CONSTRAINT measure_action_descriptions_pkey PRIMARY KEY (oid);


--
-- Name: measure_actions_oplog measure_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measure_actions_oplog
    ADD CONSTRAINT measure_actions_pkey PRIMARY KEY (oid);


--
-- Name: measure_components_oplog measure_components_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measure_components_oplog
    ADD CONSTRAINT measure_components_pkey PRIMARY KEY (oid);


--
-- Name: measure_condition_code_descriptions_oplog measure_condition_code_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measure_condition_code_descriptions_oplog
    ADD CONSTRAINT measure_condition_code_descriptions_pkey PRIMARY KEY (oid);


--
-- Name: measure_condition_codes_oplog measure_condition_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measure_condition_codes_oplog
    ADD CONSTRAINT measure_condition_codes_pkey PRIMARY KEY (oid);


--
-- Name: measure_condition_components_oplog measure_condition_components_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measure_condition_components_oplog
    ADD CONSTRAINT measure_condition_components_pkey PRIMARY KEY (oid);


--
-- Name: measure_conditions_oplog measure_conditions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measure_conditions_oplog
    ADD CONSTRAINT measure_conditions_pkey PRIMARY KEY (oid);


--
-- Name: measure_excluded_geographical_areas_oplog measure_excluded_geographical_areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measure_excluded_geographical_areas_oplog
    ADD CONSTRAINT measure_excluded_geographical_areas_pkey PRIMARY KEY (oid);


--
-- Name: measure_partial_temporary_stops_oplog measure_partial_temporary_stops_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measure_partial_temporary_stops_oplog
    ADD CONSTRAINT measure_partial_temporary_stops_pkey PRIMARY KEY (oid);


--
-- Name: measure_type_descriptions_oplog measure_type_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measure_type_descriptions_oplog
    ADD CONSTRAINT measure_type_descriptions_pkey PRIMARY KEY (oid);


--
-- Name: measure_type_series_descriptions_oplog measure_type_series_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measure_type_series_descriptions_oplog
    ADD CONSTRAINT measure_type_series_descriptions_pkey PRIMARY KEY (oid);


--
-- Name: measure_type_series_oplog measure_type_series_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measure_type_series_oplog
    ADD CONSTRAINT measure_type_series_pkey PRIMARY KEY (oid);


--
-- Name: measure_types_oplog measure_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measure_types_oplog
    ADD CONSTRAINT measure_types_pkey PRIMARY KEY (oid);


--
-- Name: measurement_unit_abbreviations measurement_unit_abbreviations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measurement_unit_abbreviations
    ADD CONSTRAINT measurement_unit_abbreviations_pkey PRIMARY KEY (id);


--
-- Name: measurement_unit_descriptions_oplog measurement_unit_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measurement_unit_descriptions_oplog
    ADD CONSTRAINT measurement_unit_descriptions_pkey PRIMARY KEY (oid);


--
-- Name: measurement_unit_qualifier_descriptions_oplog measurement_unit_qualifier_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measurement_unit_qualifier_descriptions_oplog
    ADD CONSTRAINT measurement_unit_qualifier_descriptions_pkey PRIMARY KEY (oid);


--
-- Name: measurement_unit_qualifiers_oplog measurement_unit_qualifiers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measurement_unit_qualifiers_oplog
    ADD CONSTRAINT measurement_unit_qualifiers_pkey PRIMARY KEY (oid);


--
-- Name: measurement_units_oplog measurement_units_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measurement_units_oplog
    ADD CONSTRAINT measurement_units_pkey PRIMARY KEY (oid);


--
-- Name: measurements_oplog measurements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measurements_oplog
    ADD CONSTRAINT measurements_pkey PRIMARY KEY (oid);


--
-- Name: measures_oplog measures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measures_oplog
    ADD CONSTRAINT measures_pkey PRIMARY KEY (oid);


--
-- Name: meursing_additional_codes_oplog meursing_additional_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meursing_additional_codes_oplog
    ADD CONSTRAINT meursing_additional_codes_pkey PRIMARY KEY (oid);


--
-- Name: meursing_heading_texts_oplog meursing_heading_texts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meursing_heading_texts_oplog
    ADD CONSTRAINT meursing_heading_texts_pkey PRIMARY KEY (oid);


--
-- Name: meursing_headings_oplog meursing_headings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meursing_headings_oplog
    ADD CONSTRAINT meursing_headings_pkey PRIMARY KEY (oid);


--
-- Name: meursing_subheadings_oplog meursing_subheadings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meursing_subheadings_oplog
    ADD CONSTRAINT meursing_subheadings_pkey PRIMARY KEY (oid);


--
-- Name: meursing_table_cell_components_oplog meursing_table_cell_components_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meursing_table_cell_components_oplog
    ADD CONSTRAINT meursing_table_cell_components_pkey PRIMARY KEY (oid);


--
-- Name: meursing_table_plans_oplog meursing_table_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meursing_table_plans_oplog
    ADD CONSTRAINT meursing_table_plans_pkey PRIMARY KEY (oid);


--
-- Name: modification_regulations_oplog modification_regulations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.modification_regulations_oplog
    ADD CONSTRAINT modification_regulations_pkey PRIMARY KEY (oid);


--
-- Name: monetary_exchange_periods_oplog monetary_exchange_periods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.monetary_exchange_periods_oplog
    ADD CONSTRAINT monetary_exchange_periods_pkey PRIMARY KEY (oid);


--
-- Name: monetary_exchange_rates_oplog monetary_exchange_rates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.monetary_exchange_rates_oplog
    ADD CONSTRAINT monetary_exchange_rates_pkey PRIMARY KEY (oid);


--
-- Name: monetary_unit_descriptions_oplog monetary_unit_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.monetary_unit_descriptions_oplog
    ADD CONSTRAINT monetary_unit_descriptions_pkey PRIMARY KEY (oid);


--
-- Name: monetary_units_oplog monetary_units_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.monetary_units_oplog
    ADD CONSTRAINT monetary_units_pkey PRIMARY KEY (oid);


--
-- Name: nomenclature_group_memberships_oplog nomenclature_group_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nomenclature_group_memberships_oplog
    ADD CONSTRAINT nomenclature_group_memberships_pkey PRIMARY KEY (oid);


--
-- Name: prorogation_regulation_actions_oplog prorogation_regulation_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prorogation_regulation_actions_oplog
    ADD CONSTRAINT prorogation_regulation_actions_pkey PRIMARY KEY (oid);


--
-- Name: prorogation_regulations_oplog prorogation_regulations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prorogation_regulations_oplog
    ADD CONSTRAINT prorogation_regulations_pkey PRIMARY KEY (oid);


--
-- Name: publication_sigles_oplog publication_sigles_oplog_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publication_sigles_oplog
    ADD CONSTRAINT publication_sigles_oplog_pkey PRIMARY KEY (oid);


--
-- Name: quota_associations_oplog quota_associations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quota_associations_oplog
    ADD CONSTRAINT quota_associations_pkey PRIMARY KEY (oid);


--
-- Name: quota_balance_events_oplog quota_balance_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quota_balance_events_oplog
    ADD CONSTRAINT quota_balance_events_pkey PRIMARY KEY (oid);


--
-- Name: quota_blocking_periods_oplog quota_blocking_periods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quota_blocking_periods_oplog
    ADD CONSTRAINT quota_blocking_periods_pkey PRIMARY KEY (oid);


--
-- Name: quota_critical_events_oplog quota_critical_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quota_critical_events_oplog
    ADD CONSTRAINT quota_critical_events_pkey PRIMARY KEY (oid);


--
-- Name: quota_definitions_oplog quota_definitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quota_definitions_oplog
    ADD CONSTRAINT quota_definitions_pkey PRIMARY KEY (oid);


--
-- Name: quota_exhaustion_events_oplog quota_exhaustion_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quota_exhaustion_events_oplog
    ADD CONSTRAINT quota_exhaustion_events_pkey PRIMARY KEY (oid);


--
-- Name: quota_order_number_origin_exclusions_oplog quota_order_number_origin_exclusions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quota_order_number_origin_exclusions_oplog
    ADD CONSTRAINT quota_order_number_origin_exclusions_pkey PRIMARY KEY (oid);


--
-- Name: quota_order_number_origins_oplog quota_order_number_origins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quota_order_number_origins_oplog
    ADD CONSTRAINT quota_order_number_origins_pkey PRIMARY KEY (oid);


--
-- Name: quota_order_numbers_oplog quota_order_numbers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quota_order_numbers_oplog
    ADD CONSTRAINT quota_order_numbers_pkey PRIMARY KEY (oid);


--
-- Name: quota_reopening_events_oplog quota_reopening_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quota_reopening_events_oplog
    ADD CONSTRAINT quota_reopening_events_pkey PRIMARY KEY (oid);


--
-- Name: quota_suspension_periods_oplog quota_suspension_periods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quota_suspension_periods_oplog
    ADD CONSTRAINT quota_suspension_periods_pkey PRIMARY KEY (oid);


--
-- Name: quota_unblocking_events_oplog quota_unblocking_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quota_unblocking_events_oplog
    ADD CONSTRAINT quota_unblocking_events_pkey PRIMARY KEY (oid);


--
-- Name: quota_unsuspension_events_oplog quota_unsuspension_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quota_unsuspension_events_oplog
    ADD CONSTRAINT quota_unsuspension_events_pkey PRIMARY KEY (oid);


--
-- Name: regulation_documents regulation_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regulation_documents
    ADD CONSTRAINT regulation_documents_pkey PRIMARY KEY (id);


--
-- Name: regulation_group_descriptions_oplog regulation_group_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regulation_group_descriptions_oplog
    ADD CONSTRAINT regulation_group_descriptions_pkey PRIMARY KEY (oid);


--
-- Name: regulation_groups_oplog regulation_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regulation_groups_oplog
    ADD CONSTRAINT regulation_groups_pkey PRIMARY KEY (oid);


--
-- Name: regulation_replacements_oplog regulation_replacements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regulation_replacements_oplog
    ADD CONSTRAINT regulation_replacements_pkey PRIMARY KEY (oid);


--
-- Name: regulation_role_type_descriptions_oplog regulation_role_type_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regulation_role_type_descriptions_oplog
    ADD CONSTRAINT regulation_role_type_descriptions_pkey PRIMARY KEY (oid);


--
-- Name: regulation_role_types_oplog regulation_role_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regulation_role_types_oplog
    ADD CONSTRAINT regulation_role_types_pkey PRIMARY KEY (oid);


--
-- Name: rollbacks rollbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rollbacks
    ADD CONSTRAINT rollbacks_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (filename);


--
-- Name: search_references search_references_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.search_references
    ADD CONSTRAINT search_references_pkey PRIMARY KEY (id);


--
-- Name: section_notes section_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.section_notes
    ADD CONSTRAINT section_notes_pkey PRIMARY KEY (id);


--
-- Name: sections sections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_pkey PRIMARY KEY (id);


--
-- Name: session_audits session_audits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_audits
    ADD CONSTRAINT session_audits_pkey PRIMARY KEY (id);


--
-- Name: tariff_update_conformance_errors tariff_update_conformance_errors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tariff_update_conformance_errors
    ADD CONSTRAINT tariff_update_conformance_errors_pkey PRIMARY KEY (id);


--
-- Name: tariff_updates tariff_updates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tariff_updates
    ADD CONSTRAINT tariff_updates_pkey PRIMARY KEY (filename);


--
-- Name: transmission_comments_oplog transmission_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transmission_comments_oplog
    ADD CONSTRAINT transmission_comments_pkey PRIMARY KEY (oid);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: workbasket_items workbasket_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workbasket_items
    ADD CONSTRAINT workbasket_items_pkey PRIMARY KEY (id);


--
-- Name: workbaskets_events workbaskets_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workbaskets_events
    ADD CONSTRAINT workbaskets_events_pkey PRIMARY KEY (id);


--
-- Name: workbaskets workbaskets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workbaskets
    ADD CONSTRAINT workbaskets_pkey PRIMARY KEY (id);


--
-- Name: xml_export_files xml_export_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.xml_export_files
    ADD CONSTRAINT xml_export_files_pkey PRIMARY KEY (id);


--
-- Name: abrogation_regulation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX abrogation_regulation_id ON public.measure_partial_temporary_stops_oplog USING btree (abrogation_regulation_id);


--
-- Name: acdo_addcoddesopl_nalodeonslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX acdo_addcoddesopl_nalodeonslog_operation_date ON public.additional_code_descriptions_oplog USING btree (operation_date);


--
-- Name: acdpo_addcoddesperopl_nalodeionodslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX acdpo_addcoddesperopl_nalodeionodslog_operation_date ON public.additional_code_description_periods_oplog USING btree (operation_date);


--
-- Name: aco_addcodopl_naldeslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX aco_addcodopl_naldeslog_operation_date ON public.additional_codes_oplog USING btree (operation_date);


--
-- Name: actdo_addcodtypdesopl_nalodeypeonslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX actdo_addcodtypdesopl_nalodeypeonslog_operation_date ON public.additional_code_type_descriptions_oplog USING btree (operation_date);


--
-- Name: actmto_addcodtypmeatypopl_nalodeypeurepeslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX actmto_addcodtypmeatypopl_nalodeypeurepeslog_operation_date ON public.additional_code_type_measure_types_oplog USING btree (operation_date);


--
-- Name: acto_addcodtypopl_nalodepeslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX acto_addcodtypopl_nalodepeslog_operation_date ON public.additional_code_types_oplog USING btree (operation_date);


--
-- Name: adco_desc_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX adco_desc_pk ON public.additional_code_descriptions_oplog USING btree (additional_code_description_period_sid, additional_code_type_id, additional_code_sid);


--
-- Name: adco_periods_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX adco_periods_pk ON public.additional_code_description_periods_oplog USING btree (additional_code_description_period_sid, additional_code_sid, additional_code_type_id);


--
-- Name: adco_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX adco_pk ON public.additional_codes_oplog USING btree (additional_code_sid);


--
-- Name: adco_type_desc_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX adco_type_desc_pk ON public.additional_code_type_descriptions_oplog USING btree (additional_code_type_id);


--
-- Name: adco_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX adco_type_id ON public.additional_codes_oplog USING btree (additional_code_type_id);


--
-- Name: adco_type_measure_type_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX adco_type_measure_type_pk ON public.additional_code_type_measure_types_oplog USING btree (measure_type_id, additional_code_type_id);


--
-- Name: adco_types_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX adco_types_pk ON public.additional_code_types_oplog USING btree (additional_code_type_id);


--
-- Name: additional_code_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX additional_code_type ON public.footnote_association_additional_codes_oplog USING btree (additional_code_type_id);


--
-- Name: antidumping_regulation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX antidumping_regulation ON public.base_regulations_oplog USING btree (antidumping_regulation_role, related_antidumping_regulation_id);


--
-- Name: base_regulation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX base_regulation ON public.modification_regulations_oplog USING btree (base_regulation_id, base_regulation_role);


--
-- Name: base_regulations_oplog_base_regulation_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX base_regulations_oplog_base_regulation_id_index ON public.base_regulations_oplog USING btree (base_regulation_id);


--
-- Name: base_regulations_oplog_base_regulation_role_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX base_regulations_oplog_base_regulation_role_index ON public.base_regulations_oplog USING btree (base_regulation_role);


--
-- Name: base_regulations_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX base_regulations_pk ON public.base_regulations_oplog USING btree (base_regulation_id, base_regulation_role);


--
-- Name: bro_basregopl_aseonslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bro_basregopl_aseonslog_operation_date ON public.base_regulations_oplog USING btree (operation_date);


--
-- Name: caro_comabrregopl_eteiononslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX caro_comabrregopl_eteiononslog_operation_date ON public.complete_abrogation_regulations_oplog USING btree (operation_date);


--
-- Name: cdo_cerdesopl_ateonslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cdo_cerdesopl_ateonslog_operation_date ON public.certificate_descriptions_oplog USING btree (operation_date);


--
-- Name: cdpo_cerdesperopl_ateionodslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cdpo_cerdesperopl_ateionodslog_operation_date ON public.certificate_description_periods_oplog USING btree (operation_date);


--
-- Name: cert_desc_certificate; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cert_desc_certificate ON public.certificate_descriptions_oplog USING btree (certificate_code, certificate_type_code);


--
-- Name: cert_desc_period_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cert_desc_period_pk ON public.certificate_description_periods_oplog USING btree (certificate_description_period_sid);


--
-- Name: cert_desc_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cert_desc_pk ON public.certificate_descriptions_oplog USING btree (certificate_description_period_sid);


--
-- Name: cert_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cert_pk ON public.certificates_oplog USING btree (certificate_code, certificate_type_code, validity_start_date);


--
-- Name: cert_type_code_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cert_type_code_pk ON public.certificate_type_descriptions_oplog USING btree (certificate_type_code);


--
-- Name: cert_types_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cert_types_pk ON public.certificate_types_oplog USING btree (certificate_type_code, validity_start_date);


--
-- Name: certificate; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX certificate ON public.certificate_description_periods_oplog USING btree (certificate_code, certificate_type_code);


--
-- Name: chapter_notes_chapter_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX chapter_notes_chapter_id_index ON public.chapter_notes USING btree (chapter_id);


--
-- Name: chapter_notes_section_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX chapter_notes_section_id_index ON public.chapter_notes USING btree (section_id);


--
-- Name: chief_country_cd_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX chief_country_cd_pk ON public.chief_country_code USING btree (chief_country_cd);


--
-- Name: chief_country_grp_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX chief_country_grp_pk ON public.chief_country_group USING btree (chief_country_grp);


--
-- Name: chief_mfcm_msrgp_code_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX chief_mfcm_msrgp_code_index ON public.chief_mfcm USING btree (msrgp_code);


--
-- Name: cmdty_code_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cmdty_code_index ON public.chief_comm USING btree (cmdty_code);


--
-- Name: cmpl_abrg_reg_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cmpl_abrg_reg_pk ON public.complete_abrogation_regulations_oplog USING btree (complete_abrogation_regulation_id, complete_abrogation_regulation_role);


--
-- Name: co_ceropl_teslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX co_ceropl_teslog_operation_date ON public.certificates_oplog USING btree (operation_date);


--
-- Name: code_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX code_type_id ON public.additional_code_description_periods_oplog USING btree (additional_code_type_id);


--
-- Name: complete_abrogation_regulation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX complete_abrogation_regulation ON public.base_regulations_oplog USING btree (complete_abrogation_regulation_role, complete_abrogation_regulation_id);


--
-- Name: condition_measurement_unit_qualifier_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX condition_measurement_unit_qualifier_code ON public.measure_conditions_oplog USING btree (condition_measurement_unit_qualifier_code);


--
-- Name: ctdo_certypdesopl_ateypeonslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ctdo_certypdesopl_ateypeonslog_operation_date ON public.certificate_type_descriptions_oplog USING btree (operation_date);


--
-- Name: cto_certypopl_atepeslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cto_certypopl_atepeslog_operation_date ON public.certificate_types_oplog USING btree (operation_date);


--
-- Name: data_migrations_filename_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX data_migrations_filename_index ON public.data_migrations USING btree (filename);


--
-- Name: dedo_dutexpdesopl_utyiononslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX dedo_dutexpdesopl_utyiononslog_operation_date ON public.duty_expression_descriptions_oplog USING btree (operation_date);


--
-- Name: deo_dutexpopl_utyonslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX deo_dutexpopl_utyonslog_operation_date ON public.duty_expressions_oplog USING btree (operation_date);


--
-- Name: description_period_sid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX description_period_sid ON public.additional_code_description_periods_oplog USING btree (additional_code_description_period_sid);


--
-- Name: duty_exp_desc_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX duty_exp_desc_pk ON public.duty_expression_descriptions_oplog USING btree (duty_expression_id);


--
-- Name: duty_exp_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX duty_exp_pk ON public.duty_expressions_oplog USING btree (duty_expression_id, validity_start_date);


--
-- Name: duty_expression_descriptions_oplog_duty_expression_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX duty_expression_descriptions_oplog_duty_expression_id_index ON public.duty_expression_descriptions_oplog USING btree (duty_expression_id);


--
-- Name: duty_expressions_oplog_duty_expression_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX duty_expressions_oplog_duty_expression_id_index ON public.duty_expressions_oplog USING btree (duty_expression_id);


--
-- Name: earo_expabrregopl_citiononslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX earo_expabrregopl_citiononslog_operation_date ON public.explicit_abrogation_regulations_oplog USING btree (operation_date);


--
-- Name: erndo_exprefnomdesopl_ortundureonslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX erndo_exprefnomdesopl_ortundureonslog_operation_date ON public.export_refund_nomenclature_descriptions_oplog USING btree (operation_date);


--
-- Name: erndpo_exprefnomdesperopl_ortundureionodslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX erndpo_exprefnomdesperopl_ortundureionodslog_operation_date ON public.export_refund_nomenclature_description_periods_oplog USING btree (operation_date);


--
-- Name: ernio_exprefnomindopl_ortundurentslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ernio_exprefnomindopl_ortundurentslog_operation_date ON public.export_refund_nomenclature_indents_oplog USING btree (operation_date);


--
-- Name: erno_exprefnomopl_ortundreslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX erno_exprefnomopl_ortundreslog_operation_date ON public.export_refund_nomenclatures_oplog USING btree (operation_date);


--
-- Name: exp_abrg_reg_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX exp_abrg_reg_pk ON public.explicit_abrogation_regulations_oplog USING btree (explicit_abrogation_regulation_id, explicit_abrogation_regulation_role);


--
-- Name: exp_rfnd_desc_period_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX exp_rfnd_desc_period_pk ON public.export_refund_nomenclature_description_periods_oplog USING btree (export_refund_nomenclature_sid, export_refund_nomenclature_description_period_sid);


--
-- Name: exp_rfnd_desc_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX exp_rfnd_desc_pk ON public.export_refund_nomenclature_descriptions_oplog USING btree (export_refund_nomenclature_description_period_sid);


--
-- Name: exp_rfnd_indent_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX exp_rfnd_indent_pk ON public.export_refund_nomenclature_indents_oplog USING btree (export_refund_nomenclature_indents_sid);


--
-- Name: exp_rfnd_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX exp_rfnd_pk ON public.export_refund_nomenclatures_oplog USING btree (export_refund_nomenclature_sid);


--
-- Name: explicit_abrogation_regulation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX explicit_abrogation_regulation ON public.base_regulations_oplog USING btree (explicit_abrogation_regulation_role, explicit_abrogation_regulation_id);


--
-- Name: export_refund_nomenclature; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX export_refund_nomenclature ON public.export_refund_nomenclature_descriptions_oplog USING btree (export_refund_nomenclature_sid);


--
-- Name: faaco_fooassaddcodopl_oteionnaldeslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX faaco_fooassaddcodopl_oteionnaldeslog_operation_date ON public.footnote_association_additional_codes_oplog USING btree (operation_date);


--
-- Name: faeo_fooassernopl_oteionrnslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX faeo_fooassernopl_oteionrnslog_operation_date ON public.footnote_association_erns_oplog USING btree (operation_date);


--
-- Name: fagno_fooassgoonomopl_oteionodsreslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fagno_fooassgoonomopl_oteionodsreslog_operation_date ON public.footnote_association_goods_nomenclatures_oplog USING btree (operation_date);


--
-- Name: famho_fooassmeuheaopl_oteioningngslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX famho_fooassmeuheaopl_oteioningngslog_operation_date ON public.footnote_association_meursing_headings_oplog USING btree (operation_date);


--
-- Name: famo_fooassmeaopl_oteionreslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX famo_fooassmeaopl_oteionreslog_operation_date ON public.footnote_association_measures_oplog USING btree (operation_date);


--
-- Name: fdo_foodesopl_oteonslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fdo_foodesopl_oteonslog_operation_date ON public.footnote_descriptions_oplog USING btree (operation_date);


--
-- Name: fdpo_foodesperopl_oteionodslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fdpo_foodesperopl_oteionodslog_operation_date ON public.footnote_description_periods_oplog USING btree (operation_date);


--
-- Name: fo_fooopl_teslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fo_fooopl_teslog_operation_date ON public.footnotes_oplog USING btree (operation_date);


--
-- Name: footnote_association_measures_oplog_footnote_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX footnote_association_measures_oplog_footnote_id_index ON public.footnote_association_measures_oplog USING btree (footnote_id);


--
-- Name: footnote_association_measures_oplog_footnote_type_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX footnote_association_measures_oplog_footnote_type_id_index ON public.footnote_association_measures_oplog USING btree (footnote_type_id);


--
-- Name: footnote_association_measures_oplog_measure_sid_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX footnote_association_measures_oplog_measure_sid_index ON public.footnote_association_measures_oplog USING btree (measure_sid);


--
-- Name: footnote_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX footnote_id ON public.footnote_association_measures_oplog USING btree (footnote_id);


--
-- Name: footnote_type_descriptions_oplog_footnote_type_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX footnote_type_descriptions_oplog_footnote_type_id_index ON public.footnote_type_descriptions_oplog USING btree (footnote_type_id);


--
-- Name: footnote_types_oplog_application_code_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX footnote_types_oplog_application_code_index ON public.footnote_types_oplog USING btree (application_code);


--
-- Name: footnote_types_oplog_footnote_type_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX footnote_types_oplog_footnote_type_id_index ON public.footnote_types_oplog USING btree (footnote_type_id);


--
-- Name: footnotes_oplog_footnote_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX footnotes_oplog_footnote_id_index ON public.footnotes_oplog USING btree (footnote_id);


--
-- Name: footnotes_oplog_footnote_type_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX footnotes_oplog_footnote_type_id_index ON public.footnotes_oplog USING btree (footnote_type_id);


--
-- Name: frao_ftsregactopl_ftsiononslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX frao_ftsregactopl_ftsiononslog_operation_date ON public.fts_regulation_actions_oplog USING btree (operation_date);


--
-- Name: ftdo_footypdesopl_oteypeonslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ftdo_footypdesopl_oteypeonslog_operation_date ON public.footnote_type_descriptions_oplog USING btree (operation_date);


--
-- Name: ftn_assoc_adco_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ftn_assoc_adco_pk ON public.footnote_association_additional_codes_oplog USING btree (footnote_id, footnote_type_id, additional_code_sid);


--
-- Name: ftn_assoc_ern_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ftn_assoc_ern_pk ON public.footnote_association_erns_oplog USING btree (export_refund_nomenclature_sid, footnote_id, footnote_type, validity_start_date);


--
-- Name: ftn_assoc_gono_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ftn_assoc_gono_pk ON public.footnote_association_goods_nomenclatures_oplog USING btree (footnote_id, footnote_type, goods_nomenclature_sid, validity_start_date);


--
-- Name: ftn_assoc_meurs_head_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ftn_assoc_meurs_head_pk ON public.footnote_association_meursing_headings_oplog USING btree (footnote_id, meursing_table_plan_id);


--
-- Name: ftn_desc; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ftn_desc ON public.footnote_descriptions_oplog USING btree (footnote_id, footnote_type_id, footnote_description_period_sid);


--
-- Name: ftn_desc_period; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ftn_desc_period ON public.footnote_description_periods_oplog USING btree (footnote_id, footnote_type_id, footnote_description_period_sid);


--
-- Name: ftn_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ftn_pk ON public.footnotes_oplog USING btree (footnote_id, footnote_type_id);


--
-- Name: ftn_type_desc_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ftn_type_desc_pk ON public.footnote_type_descriptions_oplog USING btree (footnote_type_id);


--
-- Name: ftn_types_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ftn_types_pk ON public.footnote_types_oplog USING btree (footnote_type_id);


--
-- Name: fto_footypopl_otepeslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fto_footypopl_otepeslog_operation_date ON public.footnote_types_oplog USING btree (operation_date);


--
-- Name: fts_reg_act_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fts_reg_act_pk ON public.fts_regulation_actions_oplog USING btree (fts_regulation_id, fts_regulation_role, stopped_regulation_id, stopped_regulation_role);


--
-- Name: ftsro_fultemstoregopl_ullarytoponslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ftsro_fultemstoregopl_ullarytoponslog_operation_date ON public.full_temporary_stop_regulations_oplog USING btree (operation_date);


--
-- Name: full_temp_explicit_abrogation_regulation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX full_temp_explicit_abrogation_regulation ON public.full_temporary_stop_regulations_oplog USING btree (explicit_abrogation_regulation_role, explicit_abrogation_regulation_id);


--
-- Name: full_temp_stop_reg_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX full_temp_stop_reg_pk ON public.full_temporary_stop_regulations_oplog USING btree (full_temporary_stop_regulation_id, full_temporary_stop_regulation_role);


--
-- Name: gado_geoaredesopl_calreaonslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gado_geoaredesopl_calreaonslog_operation_date ON public.geographical_area_descriptions_oplog USING btree (operation_date);


--
-- Name: gadpo_geoaredesperopl_calreaionodslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gadpo_geoaredesperopl_calreaionodslog_operation_date ON public.geographical_area_description_periods_oplog USING btree (operation_date);


--
-- Name: gamo_geoarememopl_calreaipslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gamo_geoarememopl_calreaipslog_operation_date ON public.geographical_area_memberships_oplog USING btree (operation_date);


--
-- Name: gao_geoareopl_caleaslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gao_geoareopl_caleaslog_operation_date ON public.geographical_areas_oplog USING btree (operation_date);


--
-- Name: geo_area_member_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX geo_area_member_pk ON public.geographical_area_memberships_oplog USING btree (geographical_area_sid, geographical_area_group_sid, validity_start_date);


--
-- Name: geog_area_desc_period_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX geog_area_desc_period_pk ON public.geographical_area_description_periods_oplog USING btree (geographical_area_description_period_sid, geographical_area_sid);


--
-- Name: geog_area_desc_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX geog_area_desc_pk ON public.geographical_area_descriptions_oplog USING btree (geographical_area_description_period_sid, geographical_area_sid);


--
-- Name: geog_area_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX geog_area_pk ON public.geographical_areas_oplog USING btree (geographical_area_id);


--
-- Name: geographical_areas_oplog_geographical_area_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX geographical_areas_oplog_geographical_area_id_index ON public.geographical_areas_oplog USING btree (geographical_area_id);


--
-- Name: geographical_areas_oplog_geographical_area_sid_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX geographical_areas_oplog_geographical_area_sid_index ON public.geographical_areas_oplog USING btree (geographical_area_sid);


--
-- Name: geographical_areas_oplog_geographical_code_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX geographical_areas_oplog_geographical_code_index ON public.geographical_areas_oplog USING btree (geographical_code);


--
-- Name: geographical_areas_oplog_parent_geographical_area_group_sid_ind; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX geographical_areas_oplog_parent_geographical_area_group_sid_ind ON public.geographical_areas_oplog USING btree (parent_geographical_area_group_sid);


--
-- Name: gndo_goonomdesopl_odsureonslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gndo_goonomdesopl_odsureonslog_operation_date ON public.goods_nomenclature_descriptions_oplog USING btree (operation_date);


--
-- Name: gndpo_goonomdesperopl_odsureionodslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gndpo_goonomdesperopl_odsureionodslog_operation_date ON public.goods_nomenclature_description_periods_oplog USING btree (operation_date);


--
-- Name: gngdo_goonomgrodesopl_odsureouponslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gngdo_goonomgrodesopl_odsureouponslog_operation_date ON public.goods_nomenclature_group_descriptions_oplog USING btree (operation_date);


--
-- Name: gngo_goonomgroopl_odsureupslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gngo_goonomgroopl_odsureupslog_operation_date ON public.goods_nomenclature_groups_oplog USING btree (operation_date);


--
-- Name: gnio_goonomindopl_odsurentslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gnio_goonomindopl_odsurentslog_operation_date ON public.goods_nomenclature_indents_oplog USING btree (operation_date);


--
-- Name: gno_goonomopl_odsreslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gno_goonomopl_odsreslog_operation_date ON public.goods_nomenclatures_oplog USING btree (operation_date);


--
-- Name: gnoo_goonomoriopl_odsureinslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gnoo_goonomoriopl_odsureinslog_operation_date ON public.goods_nomenclature_origins_oplog USING btree (operation_date);


--
-- Name: gnso_goonomsucopl_odsureorslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gnso_goonomsucopl_odsureorslog_operation_date ON public.goods_nomenclature_successors_oplog USING btree (operation_date);


--
-- Name: gono_desc_periods_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gono_desc_periods_pk ON public.goods_nomenclature_description_periods_oplog USING btree (goods_nomenclature_sid, validity_start_date, validity_end_date);


--
-- Name: gono_desc_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gono_desc_pk ON public.goods_nomenclature_descriptions_oplog USING btree (goods_nomenclature_sid, goods_nomenclature_description_period_sid);


--
-- Name: gono_desc_primary_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gono_desc_primary_key ON public.goods_nomenclature_description_periods_oplog USING btree (goods_nomenclature_description_period_sid);


--
-- Name: gono_grp_desc_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gono_grp_desc_pk ON public.goods_nomenclature_group_descriptions_oplog USING btree (goods_nomenclature_group_id, goods_nomenclature_group_type);


--
-- Name: gono_grp_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gono_grp_pk ON public.goods_nomenclature_groups_oplog USING btree (goods_nomenclature_group_id, goods_nomenclature_group_type);


--
-- Name: gono_indent_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gono_indent_pk ON public.goods_nomenclature_indents_oplog USING btree (goods_nomenclature_indent_sid);


--
-- Name: gono_origin_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gono_origin_pk ON public.goods_nomenclature_origins_oplog USING btree (goods_nomenclature_sid, derived_goods_nomenclature_item_id, derived_productline_suffix, goods_nomenclature_item_id, productline_suffix);


--
-- Name: gono_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gono_pk ON public.goods_nomenclatures_oplog USING btree (goods_nomenclature_sid);


--
-- Name: gono_succ_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gono_succ_pk ON public.goods_nomenclature_successors_oplog USING btree (goods_nomenclature_sid, absorbed_goods_nomenclature_item_id, absorbed_productline_suffix, goods_nomenclature_item_id, productline_suffix);


--
-- Name: goods_nomenclature_sid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX goods_nomenclature_sid ON public.goods_nomenclature_indents_oplog USING btree (goods_nomenclature_sid);


--
-- Name: goods_nomenclature_validity_dates; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX goods_nomenclature_validity_dates ON public.goods_nomenclature_indents_oplog USING btree (validity_start_date, validity_end_date);


--
-- Name: index_additional_code_type_descriptions_on_language_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_additional_code_type_descriptions_on_language_id ON public.additional_code_type_descriptions_oplog USING btree (language_id);


--
-- Name: index_additional_code_types_on_meursing_table_plan_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_additional_code_types_on_meursing_table_plan_id ON public.additional_code_types_oplog USING btree (meursing_table_plan_id);


--
-- Name: index_base_regulations_on_regulation_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_base_regulations_on_regulation_group_id ON public.base_regulations_oplog USING btree (regulation_group_id);


--
-- Name: index_certificate_descriptions_on_language_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_certificate_descriptions_on_language_id ON public.certificate_descriptions_oplog USING btree (language_id);


--
-- Name: index_certificate_type_descriptions_on_language_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_certificate_type_descriptions_on_language_id ON public.certificate_type_descriptions_oplog USING btree (language_id);


--
-- Name: index_chapters_sections_on_goods_nomenclature_sid_and_section_i; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chapters_sections_on_goods_nomenclature_sid_and_section_i ON public.chapters_sections USING btree (goods_nomenclature_sid, section_id);


--
-- Name: index_chief_tame; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chief_tame ON public.chief_tame USING btree (msrgp_code, msr_type, tty_code, tar_msr_no, fe_tsmp);


--
-- Name: index_chief_tamf; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chief_tamf ON public.chief_tamf USING btree (fe_tsmp, msrgp_code, msr_type, tty_code, tar_msr_no, amend_indicator);


--
-- Name: index_duty_expression_descriptions_on_language_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_duty_expression_descriptions_on_language_id ON public.duty_expression_descriptions_oplog USING btree (language_id);


--
-- Name: index_export_refund_nomenclature_descriptions_on_language_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_export_refund_nomenclature_descriptions_on_language_id ON public.export_refund_nomenclature_descriptions_oplog USING btree (language_id);


--
-- Name: index_export_refund_nomenclatures_on_goods_nomenclature_sid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_export_refund_nomenclatures_on_goods_nomenclature_sid ON public.export_refund_nomenclatures_oplog USING btree (goods_nomenclature_sid);


--
-- Name: index_footnote_descriptions_on_language_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_footnote_descriptions_on_language_id ON public.footnote_descriptions_oplog USING btree (language_id);


--
-- Name: index_footnote_type_descriptions_on_language_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_footnote_type_descriptions_on_language_id ON public.footnote_type_descriptions_oplog USING btree (language_id);


--
-- Name: index_geographical_area_descriptions_on_language_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geographical_area_descriptions_on_language_id ON public.geographical_area_descriptions_oplog USING btree (language_id);


--
-- Name: index_geographical_areas_on_parent_geographical_area_group_sid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geographical_areas_on_parent_geographical_area_group_sid ON public.geographical_areas_oplog USING btree (parent_geographical_area_group_sid);


--
-- Name: index_goods_nomenclature_descriptions_on_language_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_goods_nomenclature_descriptions_on_language_id ON public.goods_nomenclature_descriptions_oplog USING btree (language_id);


--
-- Name: index_goods_nomenclature_group_descriptions_on_language_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_goods_nomenclature_group_descriptions_on_language_id ON public.goods_nomenclature_group_descriptions_oplog USING btree (language_id);


--
-- Name: index_measure_components_on_measurement_unit_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_measure_components_on_measurement_unit_code ON public.measure_components_oplog USING btree (measurement_unit_code);


--
-- Name: index_measure_components_on_measurement_unit_qualifier_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_measure_components_on_measurement_unit_qualifier_code ON public.measure_components_oplog USING btree (measurement_unit_qualifier_code);


--
-- Name: index_measure_components_on_monetary_unit_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_measure_components_on_monetary_unit_code ON public.measure_components_oplog USING btree (monetary_unit_code);


--
-- Name: index_measure_condition_components_on_duty_expression_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_measure_condition_components_on_duty_expression_id ON public.measure_condition_components_oplog USING btree (duty_expression_id);


--
-- Name: index_measure_condition_components_on_measurement_unit_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_measure_condition_components_on_measurement_unit_code ON public.measure_condition_components_oplog USING btree (measurement_unit_code);


--
-- Name: index_measure_condition_components_on_monetary_unit_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_measure_condition_components_on_monetary_unit_code ON public.measure_condition_components_oplog USING btree (monetary_unit_code);


--
-- Name: index_measure_conditions_on_action_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_measure_conditions_on_action_code ON public.measure_conditions_oplog USING btree (action_code);


--
-- Name: index_measure_conditions_on_condition_measurement_unit_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_measure_conditions_on_condition_measurement_unit_code ON public.measure_conditions_oplog USING btree (condition_measurement_unit_code);


--
-- Name: index_measure_conditions_on_condition_monetary_unit_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_measure_conditions_on_condition_monetary_unit_code ON public.measure_conditions_oplog USING btree (condition_monetary_unit_code);


--
-- Name: index_measure_conditions_on_measure_sid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_measure_conditions_on_measure_sid ON public.measure_conditions_oplog USING btree (measure_sid);


--
-- Name: index_measure_type_descriptions_on_language_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_measure_type_descriptions_on_language_id ON public.measure_type_descriptions_oplog USING btree (language_id);


--
-- Name: index_measure_type_series_descriptions_on_language_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_measure_type_series_descriptions_on_language_id ON public.measure_type_series_descriptions_oplog USING btree (language_id);


--
-- Name: index_measure_types_on_measure_type_series_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_measure_types_on_measure_type_series_id ON public.measure_types_oplog USING btree (measure_type_series_id);


--
-- Name: index_measurement_unit_descriptions_on_language_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_measurement_unit_descriptions_on_language_id ON public.measurement_unit_descriptions_oplog USING btree (language_id);


--
-- Name: index_measures_on_additional_code_sid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_measures_on_additional_code_sid ON public.measures_oplog USING btree (additional_code_sid);


--
-- Name: index_measures_on_geographical_area_sid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_measures_on_geographical_area_sid ON public.measures_oplog USING btree (geographical_area_sid);


--
-- Name: index_measures_on_goods_nomenclature_sid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_measures_on_goods_nomenclature_sid ON public.measures_oplog USING btree (goods_nomenclature_sid);


--
-- Name: index_measures_on_measure_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_measures_on_measure_type ON public.measures_oplog USING btree (measure_type_id);


--
-- Name: index_monetary_unit_descriptions_on_language_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_monetary_unit_descriptions_on_language_id ON public.monetary_unit_descriptions_oplog USING btree (language_id);


--
-- Name: index_quota_definitions_on_measurement_unit_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_quota_definitions_on_measurement_unit_code ON public.quota_definitions_oplog USING btree (measurement_unit_code);


--
-- Name: index_quota_definitions_on_measurement_unit_qualifier_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_quota_definitions_on_measurement_unit_qualifier_code ON public.quota_definitions_oplog USING btree (measurement_unit_qualifier_code);


--
-- Name: index_quota_definitions_on_monetary_unit_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_quota_definitions_on_monetary_unit_code ON public.quota_definitions_oplog USING btree (monetary_unit_code);


--
-- Name: index_quota_definitions_on_quota_order_number_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_quota_definitions_on_quota_order_number_id ON public.quota_definitions_oplog USING btree (quota_order_number_id);


--
-- Name: index_quota_order_number_origins_on_geographical_area_sid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_quota_order_number_origins_on_geographical_area_sid ON public.quota_order_number_origins_oplog USING btree (geographical_area_sid);


--
-- Name: index_quota_suspension_periods_on_quota_definition_sid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_quota_suspension_periods_on_quota_definition_sid ON public.quota_suspension_periods_oplog USING btree (quota_definition_sid);


--
-- Name: index_regulation_group_descriptions_on_language_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_regulation_group_descriptions_on_language_id ON public.regulation_group_descriptions_oplog USING btree (language_id);


--
-- Name: index_regulation_role_type_descriptions_on_language_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_regulation_role_type_descriptions_on_language_id ON public.regulation_role_type_descriptions_oplog USING btree (language_id);


--
-- Name: item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX item_id ON public.goods_nomenclatures_oplog USING btree (goods_nomenclature_item_id, producline_suffix);


--
-- Name: justification_regulation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX justification_regulation ON public.measures_oplog USING btree (justification_regulation_role, justification_regulation_id);


--
-- Name: lang_desc_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX lang_desc_pk ON public.language_descriptions_oplog USING btree (language_id, language_code_id);


--
-- Name: language_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX language_id ON public.additional_code_descriptions_oplog USING btree (language_id);


--
-- Name: ldo_landesopl_ageonslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ldo_landesopl_ageonslog_operation_date ON public.language_descriptions_oplog USING btree (operation_date);


--
-- Name: lo_lanopl_geslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX lo_lanopl_geslog_operation_date ON public.languages_oplog USING btree (operation_date);


--
-- Name: maco_meuaddcodopl_ingnaldeslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX maco_meuaddcodopl_ingnaldeslog_operation_date ON public.meursing_additional_codes_oplog USING btree (operation_date);


--
-- Name: mado_meaactdesopl_ureiononslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mado_meaactdesopl_ureiononslog_operation_date ON public.measure_action_descriptions_oplog USING btree (operation_date);


--
-- Name: mao_meaactopl_ureonslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mao_meaactopl_ureonslog_operation_date ON public.measure_actions_oplog USING btree (operation_date);


--
-- Name: mccdo_meaconcoddesopl_ureionodeonslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mccdo_meaconcoddesopl_ureionodeonslog_operation_date ON public.measure_condition_code_descriptions_oplog USING btree (operation_date);


--
-- Name: mcco_meaconcodopl_ureiondeslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mcco_meaconcodopl_ureiondeslog_operation_date ON public.measure_condition_codes_oplog USING btree (operation_date);


--
-- Name: mcco_meaconcomopl_ureionntslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mcco_meaconcomopl_ureionntslog_operation_date ON public.measure_condition_components_oplog USING btree (operation_date);


--
-- Name: mco_meacomopl_urentslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mco_meacomopl_urentslog_operation_date ON public.measure_components_oplog USING btree (operation_date);


--
-- Name: mco_meaconopl_ureonslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mco_meaconopl_ureonslog_operation_date ON public.measure_conditions_oplog USING btree (operation_date);


--
-- Name: meas_act_desc_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX meas_act_desc_pk ON public.measure_action_descriptions_oplog USING btree (action_code);


--
-- Name: meas_act_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX meas_act_pk ON public.measure_actions_oplog USING btree (action_code, validity_start_date);


--
-- Name: meas_comp_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX meas_comp_pk ON public.measure_components_oplog USING btree (measure_sid, duty_expression_id);


--
-- Name: meas_cond_cd_desc_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX meas_cond_cd_desc_pk ON public.measure_condition_code_descriptions_oplog USING btree (condition_code);


--
-- Name: meas_cond_cd_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX meas_cond_cd_pk ON public.measure_condition_codes_oplog USING btree (condition_code, validity_start_date);


--
-- Name: meas_cond_certificate; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX meas_cond_certificate ON public.measure_conditions_oplog USING btree (certificate_code, certificate_type_code);


--
-- Name: meas_cond_comp_cd; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX meas_cond_comp_cd ON public.measure_condition_components_oplog USING btree (measure_condition_sid, duty_expression_id);


--
-- Name: meas_cond_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX meas_cond_pk ON public.measure_conditions_oplog USING btree (measure_condition_sid);


--
-- Name: meas_excl_geog_area_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX meas_excl_geog_area_pk ON public.measure_excluded_geographical_areas_oplog USING btree (geographical_area_sid);


--
-- Name: meas_excl_geog_primary_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX meas_excl_geog_primary_key ON public.measure_excluded_geographical_areas_oplog USING btree (measure_sid, excluded_geographical_area, geographical_area_sid);


--
-- Name: meas_part_temp_stop_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX meas_part_temp_stop_pk ON public.measure_partial_temporary_stops_oplog USING btree (measure_sid, partial_temporary_stop_regulation_id);


--
-- Name: meas_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX meas_pk ON public.measures_oplog USING btree (measure_sid);


--
-- Name: meas_type_desc_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX meas_type_desc_pk ON public.measure_type_descriptions_oplog USING btree (measure_type_id);


--
-- Name: meas_type_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX meas_type_pk ON public.measure_types_oplog USING btree (measure_type_id, validity_start_date);


--
-- Name: meas_type_series_desc; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX meas_type_series_desc ON public.measure_type_series_descriptions_oplog USING btree (measure_type_series_id);


--
-- Name: meas_type_series_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX meas_type_series_pk ON public.measure_type_series_oplog USING btree (measure_type_series_id);


--
-- Name: meas_unit_desc_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX meas_unit_desc_pk ON public.measurement_unit_descriptions_oplog USING btree (measurement_unit_code);


--
-- Name: meas_unit_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX meas_unit_pk ON public.measurement_units_oplog USING btree (measurement_unit_code, validity_start_date);


--
-- Name: meas_unit_qual_desc_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX meas_unit_qual_desc_pk ON public.measurement_unit_qualifier_descriptions_oplog USING btree (measurement_unit_qualifier_code);


--
-- Name: meas_unit_qual_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX meas_unit_qual_pk ON public.measurement_unit_qualifiers_oplog USING btree (measurement_unit_qualifier_code, validity_start_date);


--
-- Name: measrm_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measrm_pk ON public.measurements_oplog USING btree (measurement_unit_code, measurement_unit_qualifier_code);


--
-- Name: measure_condition_code_descriptions_oplog_condition_code_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measure_condition_code_descriptions_oplog_condition_code_index ON public.measure_condition_code_descriptions_oplog USING btree (condition_code);


--
-- Name: measure_conditions_oplog_condition_code_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measure_conditions_oplog_condition_code_index ON public.measure_conditions_oplog USING btree (condition_code);


--
-- Name: measure_conditions_oplog_measure_condition_sid_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measure_conditions_oplog_measure_condition_sid_index ON public.measure_conditions_oplog USING btree (measure_condition_sid);


--
-- Name: measure_conditions_oplog_measure_sid_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measure_conditions_oplog_measure_sid_index ON public.measure_conditions_oplog USING btree (measure_sid);


--
-- Name: measure_excluded_geographical_areas_oplog_excluded_geographical; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measure_excluded_geographical_areas_oplog_excluded_geographical ON public.measure_excluded_geographical_areas_oplog USING btree (excluded_geographical_area);


--
-- Name: measure_excluded_geographical_areas_oplog_geographical_area_sid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measure_excluded_geographical_areas_oplog_geographical_area_sid ON public.measure_excluded_geographical_areas_oplog USING btree (geographical_area_sid);


--
-- Name: measure_excluded_geographical_areas_oplog_measure_sid_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measure_excluded_geographical_areas_oplog_measure_sid_index ON public.measure_excluded_geographical_areas_oplog USING btree (measure_sid);


--
-- Name: measure_generating_regulation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measure_generating_regulation ON public.measures_oplog USING btree (measure_generating_regulation_id);


--
-- Name: measure_sid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measure_sid ON public.footnote_association_measures_oplog USING btree (measure_sid);


--
-- Name: measurement_unit_code_qualifier; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measurement_unit_code_qualifier ON public.measurement_unit_abbreviations USING btree (measurement_unit_code, measurement_unit_qualifier);


--
-- Name: measurement_unit_qualifier_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measurement_unit_qualifier_code ON public.measure_condition_components_oplog USING btree (measurement_unit_qualifier_code);


--
-- Name: measures_export_refund_nomenclature_sid_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measures_export_refund_nomenclature_sid_index ON public.measures_oplog USING btree (export_refund_nomenclature_sid);


--
-- Name: measures_goods_nomenclature_item_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measures_goods_nomenclature_item_id_index ON public.measures_oplog USING btree (goods_nomenclature_item_id);


--
-- Name: measures_oplog_additional_code_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measures_oplog_additional_code_id_index ON public.measures_oplog USING btree (additional_code_id);


--
-- Name: measures_oplog_additional_code_sid_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measures_oplog_additional_code_sid_index ON public.measures_oplog USING btree (additional_code_sid);


--
-- Name: measures_oplog_additional_code_type_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measures_oplog_additional_code_type_id_index ON public.measures_oplog USING btree (additional_code_type_id);


--
-- Name: measures_oplog_export_refund_nomenclature_sid_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measures_oplog_export_refund_nomenclature_sid_index ON public.measures_oplog USING btree (export_refund_nomenclature_sid);


--
-- Name: measures_oplog_geographical_area_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measures_oplog_geographical_area_id_index ON public.measures_oplog USING btree (geographical_area_id);


--
-- Name: measures_oplog_geographical_area_sid_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measures_oplog_geographical_area_sid_index ON public.measures_oplog USING btree (geographical_area_sid);


--
-- Name: measures_oplog_goods_nomenclature_item_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measures_oplog_goods_nomenclature_item_id_index ON public.measures_oplog USING btree (goods_nomenclature_item_id);


--
-- Name: measures_oplog_goods_nomenclature_sid_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measures_oplog_goods_nomenclature_sid_index ON public.measures_oplog USING btree (goods_nomenclature_sid);


--
-- Name: measures_oplog_justification_regulation_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measures_oplog_justification_regulation_id_index ON public.measures_oplog USING btree (justification_regulation_id);


--
-- Name: measures_oplog_justification_regulation_role_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measures_oplog_justification_regulation_role_index ON public.measures_oplog USING btree (justification_regulation_role);


--
-- Name: measures_oplog_measure_generating_regulation_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measures_oplog_measure_generating_regulation_id_index ON public.measures_oplog USING btree (measure_generating_regulation_id);


--
-- Name: measures_oplog_measure_generating_regulation_role_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measures_oplog_measure_generating_regulation_role_index ON public.measures_oplog USING btree (measure_generating_regulation_role);


--
-- Name: measures_oplog_measure_sid_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measures_oplog_measure_sid_index ON public.measures_oplog USING btree (measure_sid);


--
-- Name: measures_oplog_measure_type_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measures_oplog_measure_type_id_index ON public.measures_oplog USING btree (measure_type_id);


--
-- Name: measures_oplog_operation_date_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measures_oplog_operation_date_index ON public.measures_oplog USING btree (operation_date);


--
-- Name: measures_oplog_ordernumber_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measures_oplog_ordernumber_index ON public.measures_oplog USING btree (ordernumber);


--
-- Name: measures_oplog_reduction_indicator_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measures_oplog_reduction_indicator_index ON public.measures_oplog USING btree (reduction_indicator);


--
-- Name: measures_oplog_status_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measures_oplog_status_index ON public.measures_oplog USING btree (status);


--
-- Name: measures_oplog_validity_end_date_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measures_oplog_validity_end_date_index ON public.measures_oplog USING btree (validity_end_date);


--
-- Name: measures_oplog_validity_start_date_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measures_oplog_validity_start_date_index ON public.measures_oplog USING btree (validity_start_date);


--
-- Name: measures_oplog_workbasket_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX measures_oplog_workbasket_id_index ON public.measures_oplog USING btree (workbasket_id);


--
-- Name: megao_meaexcgeoareopl_urededcaleaslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX megao_meaexcgeoareopl_urededcaleaslog_operation_date ON public.measure_excluded_geographical_areas_oplog USING btree (operation_date);


--
-- Name: mepo_monexcperopl_aryngeodslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mepo_monexcperopl_aryngeodslog_operation_date ON public.monetary_exchange_periods_oplog USING btree (operation_date);


--
-- Name: mero_monexcratopl_aryngeteslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mero_monexcratopl_aryngeteslog_operation_date ON public.monetary_exchange_rates_oplog USING btree (operation_date);


--
-- Name: meurs_adco_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX meurs_adco_pk ON public.meursing_additional_codes_oplog USING btree (meursing_additional_code_sid);


--
-- Name: meurs_head_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX meurs_head_pk ON public.meursing_headings_oplog USING btree (meursing_table_plan_id, meursing_heading_number, row_column_code);


--
-- Name: meurs_head_txt_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX meurs_head_txt_pk ON public.meursing_heading_texts_oplog USING btree (meursing_table_plan_id, meursing_heading_number, row_column_code);


--
-- Name: meurs_subhead_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX meurs_subhead_pk ON public.meursing_subheadings_oplog USING btree (meursing_table_plan_id, meursing_heading_number, row_column_code, subheading_sequence_number);


--
-- Name: meurs_tbl_cell_comp_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX meurs_tbl_cell_comp_pk ON public.meursing_table_cell_components_oplog USING btree (meursing_table_plan_id, heading_number, row_column_code, meursing_additional_code_sid);


--
-- Name: meurs_tbl_plan_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX meurs_tbl_plan_pk ON public.meursing_table_plans_oplog USING btree (meursing_table_plan_id);


--
-- Name: mho_meuheaopl_ingngslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mho_meuheaopl_ingngslog_operation_date ON public.meursing_headings_oplog USING btree (operation_date);


--
-- Name: mhto_meuheatexopl_ingingxtslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mhto_meuheatexopl_ingingxtslog_operation_date ON public.meursing_heading_texts_oplog USING btree (operation_date);


--
-- Name: mo_meaopl_ntslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mo_meaopl_ntslog_operation_date ON public.measurements_oplog USING btree (operation_date);


--
-- Name: mo_meaopl_reslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mo_meaopl_reslog_operation_date ON public.measures_oplog USING btree (operation_date);


--
-- Name: mod_reg_complete_abrogation_regulation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mod_reg_complete_abrogation_regulation ON public.modification_regulations_oplog USING btree (complete_abrogation_regulation_id, complete_abrogation_regulation_role);


--
-- Name: mod_reg_explicit_abrogation_regulation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mod_reg_explicit_abrogation_regulation ON public.modification_regulations_oplog USING btree (explicit_abrogation_regulation_id, explicit_abrogation_regulation_role);


--
-- Name: mod_reg_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mod_reg_pk ON public.modification_regulations_oplog USING btree (modification_regulation_id, modification_regulation_role);


--
-- Name: mon_exch_period_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mon_exch_period_pk ON public.monetary_exchange_periods_oplog USING btree (monetary_exchange_period_sid, parent_monetary_unit_code);


--
-- Name: mon_exch_rate_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mon_exch_rate_pk ON public.monetary_exchange_rates_oplog USING btree (monetary_exchange_period_sid, child_monetary_unit_code);


--
-- Name: mon_unit_desc_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mon_unit_desc_pk ON public.monetary_unit_descriptions_oplog USING btree (monetary_unit_code);


--
-- Name: mon_unit_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mon_unit_pk ON public.monetary_units_oplog USING btree (monetary_unit_code, validity_start_date);


--
-- Name: mptso_meapartemstoopl_ureialaryopslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mptso_meapartemstoopl_ureialaryopslog_operation_date ON public.measure_partial_temporary_stops_oplog USING btree (operation_date);


--
-- Name: mro_modregopl_iononslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mro_modregopl_iononslog_operation_date ON public.modification_regulations_oplog USING btree (operation_date);


--
-- Name: mso_meusubopl_ingngslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mso_meusubopl_ingngslog_operation_date ON public.meursing_subheadings_oplog USING btree (operation_date);


--
-- Name: mtcco_meutabcelcomopl_ingbleellntslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mtcco_meutabcelcomopl_ingbleellntslog_operation_date ON public.meursing_table_cell_components_oplog USING btree (operation_date);


--
-- Name: mtdo_meatypdesopl_ureypeonslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mtdo_meatypdesopl_ureypeonslog_operation_date ON public.measure_type_descriptions_oplog USING btree (operation_date);


--
-- Name: mto_meatypopl_urepeslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mto_meatypopl_urepeslog_operation_date ON public.measure_types_oplog USING btree (operation_date);


--
-- Name: mtpo_meutabplaopl_ingbleanslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mtpo_meutabplaopl_ingbleanslog_operation_date ON public.meursing_table_plans_oplog USING btree (operation_date);


--
-- Name: mtsdo_meatypserdesopl_ureypeiesonslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mtsdo_meatypserdesopl_ureypeiesonslog_operation_date ON public.measure_type_series_descriptions_oplog USING btree (operation_date);


--
-- Name: mtso_meatypseropl_ureypeieslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mtso_meatypseropl_ureypeieslog_operation_date ON public.measure_type_series_oplog USING btree (operation_date);


--
-- Name: mudo_meaunidesopl_entnitonslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mudo_meaunidesopl_entnitonslog_operation_date ON public.measurement_unit_descriptions_oplog USING btree (operation_date);


--
-- Name: mudo_monunidesopl_arynitonslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mudo_monunidesopl_arynitonslog_operation_date ON public.monetary_unit_descriptions_oplog USING btree (operation_date);


--
-- Name: muo_meauniopl_entitslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX muo_meauniopl_entitslog_operation_date ON public.measurement_units_oplog USING btree (operation_date);


--
-- Name: muo_monuniopl_aryitslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX muo_monuniopl_aryitslog_operation_date ON public.monetary_units_oplog USING btree (operation_date);


--
-- Name: muqdo_meauniquadesopl_entnitieronslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX muqdo_meauniquadesopl_entnitieronslog_operation_date ON public.measurement_unit_qualifier_descriptions_oplog USING btree (operation_date);


--
-- Name: muqo_meauniquaopl_entniterslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX muqo_meauniquaopl_entniterslog_operation_date ON public.measurement_unit_qualifiers_oplog USING btree (operation_date);


--
-- Name: ngmo_nomgromemopl_ureoupipslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ngmo_nomgromemopl_ureoupipslog_operation_date ON public.nomenclature_group_memberships_oplog USING btree (operation_date);


--
-- Name: nom_grp_member_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX nom_grp_member_pk ON public.nomenclature_group_memberships_oplog USING btree (goods_nomenclature_sid, goods_nomenclature_group_id, goods_nomenclature_group_type, goods_nomenclature_item_id, validity_start_date);


--
-- Name: period_sid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX period_sid ON public.additional_code_descriptions_oplog USING btree (additional_code_description_period_sid);


--
-- Name: prao_proregactopl_ioniononslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX prao_proregactopl_ioniononslog_operation_date ON public.prorogation_regulation_actions_oplog USING btree (operation_date);


--
-- Name: primary_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX primary_key ON public.geographical_areas_oplog USING btree (geographical_area_sid);


--
-- Name: pro_proregopl_iononslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pro_proregopl_iononslog_operation_date ON public.prorogation_regulations_oplog USING btree (operation_date);


--
-- Name: prorog_reg_act_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX prorog_reg_act_pk ON public.prorogation_regulation_actions_oplog USING btree (prorogation_regulation_id, prorogation_regulation_role, prorogated_regulation_id, prorogated_regulation_role);


--
-- Name: prorog_reg_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX prorog_reg_pk ON public.prorogation_regulations_oplog USING btree (prorogation_regulation_id, prorogation_regulation_role);


--
-- Name: qao_quoassopl_otaonslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX qao_quoassopl_otaonslog_operation_date ON public.quota_associations_oplog USING btree (operation_date);


--
-- Name: qbeo_quobaleveopl_otancentslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX qbeo_quobaleveopl_otancentslog_operation_date ON public.quota_balance_events_oplog USING btree (operation_date);


--
-- Name: qbpo_quobloperopl_otaingodslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX qbpo_quobloperopl_otaingodslog_operation_date ON public.quota_blocking_periods_oplog USING btree (operation_date);


--
-- Name: qceo_quocrieveopl_otacalntslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX qceo_quocrieveopl_otacalntslog_operation_date ON public.quota_critical_events_oplog USING btree (operation_date);


--
-- Name: qdo_quodefopl_otaonslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX qdo_quodefopl_otaonslog_operation_date ON public.quota_definitions_oplog USING btree (operation_date);


--
-- Name: qeeo_quoexheveopl_otaionntslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX qeeo_quoexheveopl_otaionntslog_operation_date ON public.quota_exhaustion_events_oplog USING btree (operation_date);


--
-- Name: qono_quoordnumopl_otadererslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX qono_quoordnumopl_otadererslog_operation_date ON public.quota_order_numbers_oplog USING btree (operation_date);


--
-- Name: qonoeo_quoordnumoriexcopl_otaderberginonslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX qonoeo_quoordnumoriexcopl_otaderberginonslog_operation_date ON public.quota_order_number_origin_exclusions_oplog USING btree (operation_date);


--
-- Name: qonoo_quoordnumoriopl_otaderberinslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX qonoo_quoordnumoriopl_otaderberinslog_operation_date ON public.quota_order_number_origins_oplog USING btree (operation_date);


--
-- Name: qreo_quoreoeveopl_otaingntslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX qreo_quoreoeveopl_otaingntslog_operation_date ON public.quota_reopening_events_oplog USING btree (operation_date);


--
-- Name: qspo_quosusperopl_otaionodslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX qspo_quosusperopl_otaionodslog_operation_date ON public.quota_suspension_periods_oplog USING btree (operation_date);


--
-- Name: queo_quounbeveopl_otaingntslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX queo_quounbeveopl_otaingntslog_operation_date ON public.quota_unblocking_events_oplog USING btree (operation_date);


--
-- Name: queo_quounseveopl_otaionntslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX queo_quounseveopl_otaionntslog_operation_date ON public.quota_unsuspension_events_oplog USING btree (operation_date);


--
-- Name: quota_assoc_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX quota_assoc_pk ON public.quota_associations_oplog USING btree (main_quota_definition_sid, sub_quota_definition_sid);


--
-- Name: quota_balance_evt_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX quota_balance_evt_pk ON public.quota_balance_events_oplog USING btree (quota_definition_sid, occurrence_timestamp);


--
-- Name: quota_block_period_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX quota_block_period_pk ON public.quota_blocking_periods_oplog USING btree (quota_blocking_period_sid);


--
-- Name: quota_crit_evt_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX quota_crit_evt_pk ON public.quota_critical_events_oplog USING btree (quota_definition_sid, occurrence_timestamp);


--
-- Name: quota_def_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX quota_def_pk ON public.quota_definitions_oplog USING btree (quota_definition_sid);


--
-- Name: quota_definitions_oplog_quota_order_number_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX quota_definitions_oplog_quota_order_number_id_index ON public.quota_definitions_oplog USING btree (quota_order_number_id);


--
-- Name: quota_exhaus_evt_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX quota_exhaus_evt_pk ON public.quota_exhaustion_events_oplog USING btree (quota_definition_sid, occurrence_timestamp);


--
-- Name: quota_ord_num_excl_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX quota_ord_num_excl_pk ON public.quota_order_number_origin_exclusions_oplog USING btree (quota_order_number_origin_sid, excluded_geographical_area_sid);


--
-- Name: quota_ord_num_orig_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX quota_ord_num_orig_pk ON public.quota_order_number_origins_oplog USING btree (quota_order_number_origin_sid);


--
-- Name: quota_ord_num_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX quota_ord_num_pk ON public.quota_order_numbers_oplog USING btree (quota_order_number_sid);


--
-- Name: quota_order_number_origin_exclusions_oplog_quota_order_number_o; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX quota_order_number_origin_exclusions_oplog_quota_order_number_o ON public.quota_order_number_origin_exclusions_oplog USING btree (quota_order_number_origin_sid);


--
-- Name: quota_order_number_origins_oplog_quota_order_number_sid_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX quota_order_number_origins_oplog_quota_order_number_sid_index ON public.quota_order_number_origins_oplog USING btree (quota_order_number_sid);


--
-- Name: quota_order_numbers_oplog_quota_order_number_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX quota_order_numbers_oplog_quota_order_number_id_index ON public.quota_order_numbers_oplog USING btree (quota_order_number_id);


--
-- Name: quota_reopen_evt_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX quota_reopen_evt_pk ON public.quota_reopening_events_oplog USING btree (quota_definition_sid, occurrence_timestamp);


--
-- Name: quota_susp_period_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX quota_susp_period_pk ON public.quota_suspension_periods_oplog USING btree (quota_suspension_period_sid);


--
-- Name: quota_unblock_evt_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX quota_unblock_evt_pk ON public.quota_unblocking_events_oplog USING btree (quota_definition_sid, occurrence_timestamp);


--
-- Name: quota_unsusp_evt_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX quota_unsusp_evt_pk ON public.quota_unsuspension_events_oplog USING btree (quota_definition_sid, occurrence_timestamp);


--
-- Name: reg_grp_desc_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reg_grp_desc_pk ON public.regulation_group_descriptions_oplog USING btree (regulation_group_id);


--
-- Name: reg_grp_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reg_grp_pk ON public.regulation_groups_oplog USING btree (regulation_group_id);


--
-- Name: reg_role_type_desc_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reg_role_type_desc_pk ON public.regulation_role_type_descriptions_oplog USING btree (regulation_role_type_id);


--
-- Name: reg_role_type_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reg_role_type_pk ON public.regulation_role_types_oplog USING btree (regulation_role_type_id);


--
-- Name: rgdo_reggrodesopl_ionouponslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX rgdo_reggrodesopl_ionouponslog_operation_date ON public.regulation_group_descriptions_oplog USING btree (operation_date);


--
-- Name: rgo_reggroopl_ionupslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX rgo_reggroopl_ionupslog_operation_date ON public.regulation_groups_oplog USING btree (operation_date);


--
-- Name: rr_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX rr_pk ON public.regulation_replacements_oplog USING btree (replaced_regulation_role, replaced_regulation_id);


--
-- Name: rro_regrepopl_ionntslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX rro_regrepopl_ionntslog_operation_date ON public.regulation_replacements_oplog USING btree (operation_date);


--
-- Name: rrtdo_regroltypdesopl_ionoleypeonslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX rrtdo_regroltypdesopl_ionoleypeonslog_operation_date ON public.regulation_role_type_descriptions_oplog USING btree (operation_date);


--
-- Name: rrto_regroltypopl_ionolepeslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX rrto_regroltypopl_ionolepeslog_operation_date ON public.regulation_role_types_oplog USING btree (operation_date);


--
-- Name: search_references_referenced_id_referenced_class_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX search_references_referenced_id_referenced_class_index ON public.search_references USING btree (referenced_id, referenced_class);


--
-- Name: section_notes_section_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX section_notes_section_id_index ON public.section_notes USING btree (section_id);


--
-- Name: sid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sid ON public.additional_code_descriptions_oplog USING btree (additional_code_sid);


--
-- Name: tariff_update_conformance_errors_tariff_update_filename_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tariff_update_conformance_errors_tariff_update_filename_index ON public.tariff_update_conformance_errors USING btree (tariff_update_filename);


--
-- Name: tbl_code_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tbl_code_index ON public.chief_tbl9 USING btree (tbl_code);


--
-- Name: tbl_type_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tbl_type_index ON public.chief_tbl9 USING btree (tbl_type);


--
-- Name: tco_tracomopl_ionntslog_operation_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tco_tracomopl_ionntslog_operation_date ON public.transmission_comments_oplog USING btree (operation_date);


--
-- Name: trans_comm_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX trans_comm_pk ON public.transmission_comments_oplog USING btree (comment_sid, language_id);


--
-- Name: type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX type_id ON public.additional_code_descriptions_oplog USING btree (additional_code_type_id);


--
-- Name: uoq_code_cdu2_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX uoq_code_cdu2_index ON public.chief_comm USING btree (uoq_code_cdu2);


--
-- Name: uoq_code_cdu3_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX uoq_code_cdu3_index ON public.chief_comm USING btree (uoq_code_cdu3);


--
-- Name: user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_id ON public.rollbacks USING btree (user_id);


--
-- Name: xml_export_files_envelope_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX xml_export_files_envelope_id_index ON public.xml_export_files USING btree (envelope_id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;
INSERT INTO "schema_migrations" ("filename") VALUES ('1342519058_create_schema.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20120726092749_duty_amount_expressed_in_float.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20120726162358_measure_sid_to_be_unsigned.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20120730121153_add_gono_id_index_on_measures.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20120803132451_fix_chief_columns.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20120805223427_rename_qta_elig_use_lstrubg_chief.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20120805224946_add_transformed_to_chief_tables.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20120806141008_add_note_tables.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20120807111730_add_national_attributes.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20120810083616_fix_datatypes.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20120810085137_add_national_abbreviation_to_certificates.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20120810104725_create_add_acronym_to_measure_types.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20120810105500_adjust_fields_for_chief.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20120810114211_add_national_to_certificate_description_periods.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20120820074642_create_search_references.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20120820181332_measure_sid_should_be_signed.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20120821151733_add_amend_indicator_to_chief.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20120823142700_change_decimals_in_chief.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20120911111821_change_chief_duty_expressions_to_boolean.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20120912143520_add_indexes_to_chief_records.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20120913170136_add_national_to_measures.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20120919073610_remove_export_indication_from_measures.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20120921072412_export_refund_changes.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20121001141720_adjust_chief_keys.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20121003061643_add_origin_to_chief_records.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20121004111601_create_tariff_updates.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20121004172558_extend_tariff_updates_size.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20121009120028_add_tariff_measure_number.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20121012080652_modify_primary_keys.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20121015072148_drop_tamf_le_tsmp.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20121029133148_convert_additional_codes.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20121109121107_fix_chief_last_effective_dates.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20121129094209_add_invalidated_columns_to_measures.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20121204130816_create_hidden_goods_nomenclatures.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20130118122518_create_comms.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20130118150014_add_origin_to_comm.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20130123090129_create_tbl9s.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20130123095635_add_processed_indicator_to_chief_tables.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20130123125153_adjust_chief_decimal_columns.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20130124080334_add_comm_tbl9_indexes.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20130124085812_fix_chief_field_lengths.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20130207150008_add_oplog_columns.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20130208142043_rename_to_oplog_tables.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20130208155058_add_model_views.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20130208170444_add_index_on_operation_date.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20130208205715_remove_updated_at_columns.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20130209072950_modify_created_at_to_use_timestamp.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20130215093803_change_quota_volume_type.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20130220094325_add_index_for_regulation_replacements.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20130221132447_make_effective_end_dates_timestamps.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20130221140444_change_export_refund_nomenclature_indent_type.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20130417135357_add_users_table.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180212145253_create_initial_schema.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180228181242_create_xml_exports.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180301160928_add_xml_data_to_xml_export_files.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180305221434_remove_filename_from_xml_export_files.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180305224610_add_relevant_date_to_xml_export_files.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180305224900_add_issue_date_in_xml_export_files.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180328135527_create_node_envelopes.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180328144030_create_node_transactions.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180328144132_create_node_messages.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180402091320_remove_type_from_xml_nodes.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180402142849_add_record_to_node_messages.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180402154232_change_record_id_to_record_filter_ops_in_node_messages.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180406152439_remove_xml_nodes.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180410100532_create_db_rollbacks.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180417135500_change_relevant_date_in_xml_export_files.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180417141804_change_clear_date_in_db_rollbacks.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180423062256_create_regulation_documents.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180423084717_add_added_by_id_and_added_at_to_managing_tables.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180423085320_update_regulation_related_bd_views.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180425165312_add_national_flag_to_regulation_related_db_tables.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180425171028_add_national_flag_to_regulation_documents.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180425171418_add_national_flag_to_measure_related_db_tables.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180504143240_add_added_by_id_and_added_at_to_measures.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180505084755_add_added_at_and_added_by_id_to_footnotes.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180505091501_add_added_at_and_added_by_to_footnote_association_measures.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180505092846_add_added_at_and_added_by_id_to_footnote_descriptions.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180509152938_add_regulations_search_pg_view.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180516133210_add_base_64_data_to_xml_export_files.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180516133707_add_zip_data_to_xml_export_files.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180516164658_add_meta_data_to_xml_export_files.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180521132612_add_status_to_measures.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180521160953_add_some_tracking_fields_to_measures.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180521170635_create_measure_groups.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180521171648_add_measure_group_id_to_measures.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180522084958_add_searchable_data_to_measures_oplog.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180607071508_add_searchable_data_updated_at_to_measures.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180618144957_create_workbaskets.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180618150316_remove_measure_groups.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180619082412_add_some_fields_to_workbasket.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180619083622_create_workbaskets_events.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180619083954_rename_title_to_event_type_in_workbaskets_events.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180626120716_add_workbasket_items.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180626133140_add_data_to_workbasket_items.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180626133556_add_record_key_to_workbasket_items.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180626154859_add_initial_items_populated_to_workbaskets.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180626174214_add_batches_loaded_to_workbaskets.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20130418073137_rename_permission_column.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20130801074451_increase_quota_balance_events_precision.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20130808103859_extend_user_table_with_additional_fields.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20130809075350_change_chapter_note_foreign_key_type.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20130916082304_add_foreign_keys_to_search_references.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20131113142525_add_search_references_polymorphic_association.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20140410213345_create_rollbacks.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20140424105255_add_columns_to_tariff_updates.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20140526161142_add_error_column_to_updates.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20140527124014_change_column_in_rollbacks.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20140715224356_create_measurement_unit_abbreviations.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20140721090137_add_organisation_slug_to_user.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20140722151202_add_error_backtrace_to_tariff_updates.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20140731161233_create_tariff_update_conformance_errors.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20150114110937_quota_critical_events_oplog_primary_key.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20150406165721_add_disabled_to_user.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20150507133620_add_organisation_content_id_to_user.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20151214224024_add_model_views_reloaded.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20151214230831_quota_critical_events_view_reloaded.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20161209195324_alter_footnotes_foonote_id_lenght.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20170117212158_create_audits.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20170331125740_create_data_migrations.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20171228082821_create_publication_sigles.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180629173432_change_workbasket_items.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180629174201_add_changed_and_validation_errors_to_workbasket_items.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180702142649_add_search_code_to_workbaskets.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180702144052_add_all_batched_loaded_to_workbaskets.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180709182215_create_create_measures_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180709182401_add_settings_jsonb_to_create_measures_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180709182617_add_timestamps_to_create_measures_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180717164406_change_create_measures_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180717165903_add_more_fields_to_create_measures_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180718101124_change_validation_field_create_measures_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180718174824_fix_footnote_id_characters_limit_in_associations.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180720100558_add_measure_sids_to_create_measures_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180722185024_add_workbasket_attributes_to_db_tables.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180726104556_add_workbasket_attrs_to_measure_excluded_geographical_areas.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180726140522_update_xml_exportable_data_with_workbasket_fields.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180727172730_create_create_quota_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180727173036_add_more_fields_to_create_quota_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180730134551_add_more_fields_to_create_quota_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180802084730_add_fields_to_full_temporary_stop_regulations.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180807180500_add_initial_search_results_code_to_workbaskets.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180820092723_add_internal_fields_to_duty_expressions.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180823124148_add_workbasket_type_of_quota_to_quota_definitions.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180830115631_create_create_regulation_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180905171759_create_bulk_edit_of_measures_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180905172132_add_extra_columns_to_bulk_edit_of_measures_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180905172706_remove_no_longer_used_options_from_workbaskets.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180906092926_migrate_specific_fields_from_workbaskets.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180907162945_add_original_measure_sid_to_measures_oplog.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180914160726_add_workbasket_to_xml_export_files.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180918204647_add_errors_to_xml_export_files.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180924103425_add_system_fileds_to_quota_assotiation.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180925161300_add_parent_quota_period_sids_to_create_quota_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180928163638_create_create_geographical_area_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180926170510_create_create_additional_code_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180928120642_add_added_at_and_added_by_id_to_additional_codes.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181006113320_add_approver_user_to_users.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181006161913_add_workflow_fields_to_workbaskets.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181003132323_create_bulk_edit_of_additional_codes_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181004201410_create_bulk_edit_of_quotas_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181009114102_add_ordernumber_index_to_measures.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181009122123_add_indexes_to_measures.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181011184220_add_search_indexes_to_speed_up.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181011190000_add_more_search_indexes_to_speed_up.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181012181311_rollback_duty_expression_indexes.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181012184040_add_updated_at_to_sections.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180724155759_fix_footnote_id_characters_limit_in_associations.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181011140533_change_operation_date_type.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181012133937_create_all_additional_codes_view.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181016175408_add_workbasket_related_columns_to_geo_areas_tables.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181017095105_create_create_footnotes_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181017141845_create_certificate_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181017165251_add_workbasket_related_columns_to_certificate_tables.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181019151225_edit_footnotes_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181019161518_add_original_fields_to_edit_footnote_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181021085816_add_workbasket_fields_to_footnote_associations.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181011092756_change_bulk_edit_of_quotas_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181016202844_add_quota_settings_to_edit_quota.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181017151545_add_workbasket_fileds_to_quota_relations.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181019094231_modify_quota_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181019153740_add_row_id_to_workbasket_item.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181022065914_create_edit_certificate_settings_table.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181022074953_add_original_fields_to_edit_certificates_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181022164645_create_edit_geographical_areas_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181022164836_add_original_fields_to_edit_geographical_areas_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181022112903_change_bulk_edit_of_quota_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181204111717_add_envelope_id_to_xml_export_files.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20190131153106_remove_unneeded_files_from_xml_export_files.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20190201161401_change_xml_export_from_dates_to_workbasket.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20190212163200_add_user_id_to_xml_export_files.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20190320142706_create_session_audits.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20190603135337_replace_all_additional_codes_view.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20190625152340_create_edit_nomenclature_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20190712143348_add_workbasket_fields_goods_nomenclature_description.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20190716105325_add_main_step_validation_passed_to_edit_nomenclature_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20190725135752_add_original_description_to_edit_nomenclature_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20190916111955_create_edit_regulation_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20191004104951_create_quota_association_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20191021140811_create_quota_suspension_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20191022083212_create_delete_quota_association_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20191104110933_create_edit_quota_suspension_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20191105131733_create_create_nomenclature_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20191113160652_add_workbasket_fields_goods_nomenclature.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20191115160657_create_delete_quota_suspension_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20191118132010_add_columns_to_edit_quota_suspension_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20191125154127_create_quota_blocking_period_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20191127110431_create_edit_quota_blocking_period_workbasket_settings.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20191202145535_change_regulations_search_pg_view.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20200106095903_create_delete_quota_blocking_period_workbasket_settings.rb');
