--
-- PostgreSQL database dump
--


-- Dumped from database version 18.4 (Debian 18.4-1.pgdg13+1)
-- Dumped by pg_dump version 18.4 (Debian 18.4-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: rand(); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION public.rand() RETURNS double precision
    LANGUAGE sql
    AS $$SELECT random();$$;


ALTER FUNCTION public.rand() OWNER TO root;

--
-- Name: substring_index(text, text, integer); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION public.substring_index(text, text, integer) RETURNS text
    LANGUAGE sql
    AS $_$SELECT array_to_string((string_to_array($1, $2)) [1:$3], $2);$_$;


ALTER FUNCTION public.substring_index(text, text, integer) OWNER TO root;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: batch; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.batch (
    bid integer NOT NULL,
    token character varying(64) NOT NULL,
    "timestamp" integer NOT NULL,
    batch bytea,
    CONSTRAINT batch_bid_check CHECK ((bid >= 0))
);


ALTER TABLE public.batch OWNER TO root;

--
-- Name: TABLE batch; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.batch IS 'Stores details about batches (processes that run in multiple HTTP requests).';


--
-- Name: COLUMN batch.bid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.batch.bid IS 'Primary Key: Unique batch ID.';


--
-- Name: COLUMN batch.token; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.batch.token IS 'A string token generated against the current user''s session id and the batch id, used to ensure that only the user who submitted the batch can effectively access it.';


--
-- Name: COLUMN batch."timestamp"; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.batch."timestamp" IS 'A Unix timestamp indicating when this batch was submitted for processing. Stale batches are purged at cron time.';


--
-- Name: COLUMN batch.batch; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.batch.batch IS 'A serialized array containing the processing data for the batch.';


--
-- Name: batch_bid_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.batch_bid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.batch_bid_seq OWNER TO root;

--
-- Name: batch_bid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.batch_bid_seq OWNED BY public.batch.bid;


--
-- Name: block_content; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.block_content (
    id integer NOT NULL,
    revision_id bigint,
    type character varying(32) NOT NULL,
    uuid character varying(128) NOT NULL,
    langcode character varying(12) NOT NULL,
    CONSTRAINT block_content_id_check CHECK ((id >= 0)),
    CONSTRAINT block_content_revision_id_check CHECK ((revision_id >= 0))
);


ALTER TABLE public.block_content OWNER TO root;

--
-- Name: TABLE block_content; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.block_content IS 'The base table for block_content entities.';


--
-- Name: COLUMN block_content.type; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.block_content.type IS 'The ID of the target entity.';


--
-- Name: block_content__body; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.block_content__body (
    bundle character varying(128) DEFAULT ''::character varying NOT NULL,
    deleted smallint DEFAULT 0 NOT NULL,
    entity_id bigint NOT NULL,
    revision_id bigint NOT NULL,
    langcode character varying(32) DEFAULT ''::character varying NOT NULL,
    delta bigint NOT NULL,
    body_value text NOT NULL,
    body_format character varying(255),
    CONSTRAINT block_content__body_delta_check CHECK ((delta >= 0)),
    CONSTRAINT block_content__body_entity_id_check CHECK ((entity_id >= 0)),
    CONSTRAINT block_content__body_revision_id_check CHECK ((revision_id >= 0))
);


ALTER TABLE public.block_content__body OWNER TO root;

--
-- Name: TABLE block_content__body; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.block_content__body IS 'Data storage for block_content field body.';


--
-- Name: COLUMN block_content__body.bundle; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.block_content__body.bundle IS 'The field instance bundle to which this row belongs, used when deleting a field instance';


--
-- Name: COLUMN block_content__body.deleted; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.block_content__body.deleted IS 'A boolean indicating whether this data item has been deleted';


--
-- Name: COLUMN block_content__body.entity_id; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.block_content__body.entity_id IS 'The entity id this data is attached to';


--
-- Name: COLUMN block_content__body.revision_id; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.block_content__body.revision_id IS 'The entity revision id this data is attached to';


--
-- Name: COLUMN block_content__body.langcode; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.block_content__body.langcode IS 'The language code for this data item.';


--
-- Name: COLUMN block_content__body.delta; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.block_content__body.delta IS 'The sequence number for this data item, used for multi-value fields';


--
-- Name: block_content_field_data; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.block_content_field_data (
    id bigint NOT NULL,
    revision_id bigint NOT NULL,
    type character varying(32) NOT NULL,
    langcode character varying(12) NOT NULL,
    status smallint NOT NULL,
    info character varying(255),
    changed integer,
    reusable smallint,
    default_langcode smallint NOT NULL,
    revision_translation_affected smallint,
    CONSTRAINT block_content_field_data_id_check CHECK ((id >= 0)),
    CONSTRAINT block_content_field_data_revision_id_check CHECK ((revision_id >= 0))
);


ALTER TABLE public.block_content_field_data OWNER TO root;

--
-- Name: TABLE block_content_field_data; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.block_content_field_data IS 'The data table for block_content entities.';


--
-- Name: COLUMN block_content_field_data.type; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.block_content_field_data.type IS 'The ID of the target entity.';


--
-- Name: block_content_field_revision; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.block_content_field_revision (
    id bigint NOT NULL,
    revision_id bigint NOT NULL,
    langcode character varying(12) NOT NULL,
    status smallint NOT NULL,
    info character varying(255),
    changed integer,
    default_langcode smallint NOT NULL,
    revision_translation_affected smallint,
    CONSTRAINT block_content_field_revision_id_check CHECK ((id >= 0)),
    CONSTRAINT block_content_field_revision_revision_id_check CHECK ((revision_id >= 0))
);


ALTER TABLE public.block_content_field_revision OWNER TO root;

--
-- Name: TABLE block_content_field_revision; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.block_content_field_revision IS 'The revision data table for block_content entities.';


--
-- Name: block_content_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.block_content_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.block_content_id_seq OWNER TO root;

--
-- Name: block_content_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.block_content_id_seq OWNED BY public.block_content.id;


--
-- Name: block_content_revision; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.block_content_revision (
    id bigint NOT NULL,
    revision_id integer NOT NULL,
    langcode character varying(12) NOT NULL,
    revision_user bigint,
    revision_created integer,
    revision_log text,
    revision_default smallint,
    CONSTRAINT block_content_revision_id_check1 CHECK ((id >= 0)),
    CONSTRAINT block_content_revision_revision_id_check CHECK ((revision_id >= 0)),
    CONSTRAINT block_content_revision_revision_user_check CHECK ((revision_user >= 0))
);


ALTER TABLE public.block_content_revision OWNER TO root;

--
-- Name: TABLE block_content_revision; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.block_content_revision IS 'The revision table for block_content entities.';


--
-- Name: COLUMN block_content_revision.revision_user; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.block_content_revision.revision_user IS 'The ID of the target entity.';


--
-- Name: block_content_revision__body; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.block_content_revision__body (
    bundle character varying(128) DEFAULT ''::character varying NOT NULL,
    deleted smallint DEFAULT 0 NOT NULL,
    entity_id bigint NOT NULL,
    revision_id bigint NOT NULL,
    langcode character varying(32) DEFAULT ''::character varying NOT NULL,
    delta bigint NOT NULL,
    body_value text NOT NULL,
    body_format character varying(255),
    CONSTRAINT block_content_revision__body_delta_check CHECK ((delta >= 0)),
    CONSTRAINT block_content_revision__body_entity_id_check CHECK ((entity_id >= 0)),
    CONSTRAINT block_content_revision__body_revision_id_check CHECK ((revision_id >= 0))
);


ALTER TABLE public.block_content_revision__body OWNER TO root;

--
-- Name: TABLE block_content_revision__body; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.block_content_revision__body IS 'Revision archive storage for block_content field body.';


--
-- Name: COLUMN block_content_revision__body.bundle; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.block_content_revision__body.bundle IS 'The field instance bundle to which this row belongs, used when deleting a field instance';


--
-- Name: COLUMN block_content_revision__body.deleted; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.block_content_revision__body.deleted IS 'A boolean indicating whether this data item has been deleted';


--
-- Name: COLUMN block_content_revision__body.entity_id; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.block_content_revision__body.entity_id IS 'The entity id this data is attached to';


--
-- Name: COLUMN block_content_revision__body.revision_id; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.block_content_revision__body.revision_id IS 'The entity revision id this data is attached to';


--
-- Name: COLUMN block_content_revision__body.langcode; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.block_content_revision__body.langcode IS 'The language code for this data item.';


--
-- Name: COLUMN block_content_revision__body.delta; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.block_content_revision__body.delta IS 'The sequence number for this data item, used for multi-value fields';


--
-- Name: block_content_revision_revision_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.block_content_revision_revision_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.block_content_revision_revision_id_seq OWNER TO root;

--
-- Name: block_content_revision_revision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.block_content_revision_revision_id_seq OWNED BY public.block_content_revision.revision_id;


--
-- Name: cache_bootstrap; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.cache_bootstrap (
    cid character varying(255) DEFAULT ''::character varying NOT NULL,
    data bytea,
    expire bigint DEFAULT 0 NOT NULL,
    created numeric(14,3) DEFAULT 0 NOT NULL,
    serialized smallint DEFAULT 0 NOT NULL,
    tags text,
    checksum character varying(255) NOT NULL
);


ALTER TABLE public.cache_bootstrap OWNER TO root;

--
-- Name: TABLE cache_bootstrap; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.cache_bootstrap IS 'Storage for the cache API.';


--
-- Name: COLUMN cache_bootstrap.cid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_bootstrap.cid IS 'Primary Key: Unique cache ID.';


--
-- Name: COLUMN cache_bootstrap.data; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_bootstrap.data IS 'A collection of data to cache.';


--
-- Name: COLUMN cache_bootstrap.expire; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_bootstrap.expire IS 'A Unix timestamp indicating when the cache entry should expire, or -1 for never.';


--
-- Name: COLUMN cache_bootstrap.created; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_bootstrap.created IS 'A timestamp with millisecond precision indicating when the cache entry was created.';


--
-- Name: COLUMN cache_bootstrap.serialized; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_bootstrap.serialized IS 'A flag to indicate whether content is serialized (1) or not (0).';


--
-- Name: COLUMN cache_bootstrap.tags; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_bootstrap.tags IS 'Space-separated list of cache tags for this entry.';


--
-- Name: COLUMN cache_bootstrap.checksum; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_bootstrap.checksum IS 'The tag invalidation checksum when this entry was saved.';


--
-- Name: cache_config; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.cache_config (
    cid character varying(255) DEFAULT ''::character varying NOT NULL,
    data bytea,
    expire bigint DEFAULT 0 NOT NULL,
    created numeric(14,3) DEFAULT 0 NOT NULL,
    serialized smallint DEFAULT 0 NOT NULL,
    tags text,
    checksum character varying(255) NOT NULL
);


ALTER TABLE public.cache_config OWNER TO root;

--
-- Name: TABLE cache_config; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.cache_config IS 'Storage for the cache API.';


--
-- Name: COLUMN cache_config.cid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_config.cid IS 'Primary Key: Unique cache ID.';


--
-- Name: COLUMN cache_config.data; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_config.data IS 'A collection of data to cache.';


--
-- Name: COLUMN cache_config.expire; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_config.expire IS 'A Unix timestamp indicating when the cache entry should expire, or -1 for never.';


--
-- Name: COLUMN cache_config.created; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_config.created IS 'A timestamp with millisecond precision indicating when the cache entry was created.';


--
-- Name: COLUMN cache_config.serialized; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_config.serialized IS 'A flag to indicate whether content is serialized (1) or not (0).';


--
-- Name: COLUMN cache_config.tags; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_config.tags IS 'Space-separated list of cache tags for this entry.';


--
-- Name: COLUMN cache_config.checksum; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_config.checksum IS 'The tag invalidation checksum when this entry was saved.';


--
-- Name: cache_container; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.cache_container (
    cid character varying(255) DEFAULT ''::character varying NOT NULL,
    data bytea,
    expire bigint DEFAULT 0 NOT NULL,
    created numeric(14,3) DEFAULT 0 NOT NULL,
    serialized smallint DEFAULT 0 NOT NULL,
    tags text,
    checksum character varying(255) NOT NULL
);


ALTER TABLE public.cache_container OWNER TO root;

--
-- Name: TABLE cache_container; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.cache_container IS 'Storage for the cache API.';


--
-- Name: COLUMN cache_container.cid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_container.cid IS 'Primary Key: Unique cache ID.';


--
-- Name: COLUMN cache_container.data; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_container.data IS 'A collection of data to cache.';


--
-- Name: COLUMN cache_container.expire; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_container.expire IS 'A Unix timestamp indicating when the cache entry should expire, or -1 for never.';


--
-- Name: COLUMN cache_container.created; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_container.created IS 'A timestamp with millisecond precision indicating when the cache entry was created.';


--
-- Name: COLUMN cache_container.serialized; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_container.serialized IS 'A flag to indicate whether content is serialized (1) or not (0).';


--
-- Name: COLUMN cache_container.tags; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_container.tags IS 'Space-separated list of cache tags for this entry.';


--
-- Name: COLUMN cache_container.checksum; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_container.checksum IS 'The tag invalidation checksum when this entry was saved.';


--
-- Name: cache_data; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.cache_data (
    cid character varying(255) DEFAULT ''::character varying NOT NULL,
    data bytea,
    expire bigint DEFAULT 0 NOT NULL,
    created numeric(14,3) DEFAULT 0 NOT NULL,
    serialized smallint DEFAULT 0 NOT NULL,
    tags text,
    checksum character varying(255) NOT NULL
);


ALTER TABLE public.cache_data OWNER TO root;

--
-- Name: TABLE cache_data; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.cache_data IS 'Storage for the cache API.';


--
-- Name: COLUMN cache_data.cid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_data.cid IS 'Primary Key: Unique cache ID.';


--
-- Name: COLUMN cache_data.data; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_data.data IS 'A collection of data to cache.';


--
-- Name: COLUMN cache_data.expire; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_data.expire IS 'A Unix timestamp indicating when the cache entry should expire, or -1 for never.';


--
-- Name: COLUMN cache_data.created; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_data.created IS 'A timestamp with millisecond precision indicating when the cache entry was created.';


--
-- Name: COLUMN cache_data.serialized; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_data.serialized IS 'A flag to indicate whether content is serialized (1) or not (0).';


--
-- Name: COLUMN cache_data.tags; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_data.tags IS 'Space-separated list of cache tags for this entry.';


--
-- Name: COLUMN cache_data.checksum; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_data.checksum IS 'The tag invalidation checksum when this entry was saved.';


--
-- Name: cache_default; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.cache_default (
    cid character varying(255) DEFAULT ''::character varying NOT NULL,
    data bytea,
    expire bigint DEFAULT 0 NOT NULL,
    created numeric(14,3) DEFAULT 0 NOT NULL,
    serialized smallint DEFAULT 0 NOT NULL,
    tags text,
    checksum character varying(255) NOT NULL
);


ALTER TABLE public.cache_default OWNER TO root;

--
-- Name: TABLE cache_default; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.cache_default IS 'Storage for the cache API.';


--
-- Name: COLUMN cache_default.cid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_default.cid IS 'Primary Key: Unique cache ID.';


--
-- Name: COLUMN cache_default.data; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_default.data IS 'A collection of data to cache.';


--
-- Name: COLUMN cache_default.expire; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_default.expire IS 'A Unix timestamp indicating when the cache entry should expire, or -1 for never.';


--
-- Name: COLUMN cache_default.created; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_default.created IS 'A timestamp with millisecond precision indicating when the cache entry was created.';


--
-- Name: COLUMN cache_default.serialized; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_default.serialized IS 'A flag to indicate whether content is serialized (1) or not (0).';


--
-- Name: COLUMN cache_default.tags; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_default.tags IS 'Space-separated list of cache tags for this entry.';


--
-- Name: COLUMN cache_default.checksum; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_default.checksum IS 'The tag invalidation checksum when this entry was saved.';


--
-- Name: cache_discovery; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.cache_discovery (
    cid character varying(255) DEFAULT ''::character varying NOT NULL,
    data bytea,
    expire bigint DEFAULT 0 NOT NULL,
    created numeric(14,3) DEFAULT 0 NOT NULL,
    serialized smallint DEFAULT 0 NOT NULL,
    tags text,
    checksum character varying(255) NOT NULL
);


ALTER TABLE public.cache_discovery OWNER TO root;

--
-- Name: TABLE cache_discovery; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.cache_discovery IS 'Storage for the cache API.';


--
-- Name: COLUMN cache_discovery.cid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_discovery.cid IS 'Primary Key: Unique cache ID.';


--
-- Name: COLUMN cache_discovery.data; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_discovery.data IS 'A collection of data to cache.';


--
-- Name: COLUMN cache_discovery.expire; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_discovery.expire IS 'A Unix timestamp indicating when the cache entry should expire, or -1 for never.';


--
-- Name: COLUMN cache_discovery.created; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_discovery.created IS 'A timestamp with millisecond precision indicating when the cache entry was created.';


--
-- Name: COLUMN cache_discovery.serialized; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_discovery.serialized IS 'A flag to indicate whether content is serialized (1) or not (0).';


--
-- Name: COLUMN cache_discovery.tags; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_discovery.tags IS 'Space-separated list of cache tags for this entry.';


--
-- Name: COLUMN cache_discovery.checksum; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_discovery.checksum IS 'The tag invalidation checksum when this entry was saved.';


--
-- Name: cache_dynamic_page_cache; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.cache_dynamic_page_cache (
    cid character varying(255) DEFAULT ''::character varying NOT NULL,
    data bytea,
    expire bigint DEFAULT 0 NOT NULL,
    created numeric(14,3) DEFAULT 0 NOT NULL,
    serialized smallint DEFAULT 0 NOT NULL,
    tags text,
    checksum character varying(255) NOT NULL
);


ALTER TABLE public.cache_dynamic_page_cache OWNER TO root;

--
-- Name: TABLE cache_dynamic_page_cache; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.cache_dynamic_page_cache IS 'Storage for the cache API.';


--
-- Name: COLUMN cache_dynamic_page_cache.cid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_dynamic_page_cache.cid IS 'Primary Key: Unique cache ID.';


--
-- Name: COLUMN cache_dynamic_page_cache.data; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_dynamic_page_cache.data IS 'A collection of data to cache.';


--
-- Name: COLUMN cache_dynamic_page_cache.expire; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_dynamic_page_cache.expire IS 'A Unix timestamp indicating when the cache entry should expire, or -1 for never.';


--
-- Name: COLUMN cache_dynamic_page_cache.created; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_dynamic_page_cache.created IS 'A timestamp with millisecond precision indicating when the cache entry was created.';


--
-- Name: COLUMN cache_dynamic_page_cache.serialized; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_dynamic_page_cache.serialized IS 'A flag to indicate whether content is serialized (1) or not (0).';


--
-- Name: COLUMN cache_dynamic_page_cache.tags; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_dynamic_page_cache.tags IS 'Space-separated list of cache tags for this entry.';


--
-- Name: COLUMN cache_dynamic_page_cache.checksum; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_dynamic_page_cache.checksum IS 'The tag invalidation checksum when this entry was saved.';


--
-- Name: cache_entity; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.cache_entity (
    cid character varying(255) DEFAULT ''::character varying NOT NULL,
    data bytea,
    expire bigint DEFAULT 0 NOT NULL,
    created numeric(14,3) DEFAULT 0 NOT NULL,
    serialized smallint DEFAULT 0 NOT NULL,
    tags text,
    checksum character varying(255) NOT NULL
);


ALTER TABLE public.cache_entity OWNER TO root;

--
-- Name: TABLE cache_entity; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.cache_entity IS 'Storage for the cache API.';


--
-- Name: COLUMN cache_entity.cid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_entity.cid IS 'Primary Key: Unique cache ID.';


--
-- Name: COLUMN cache_entity.data; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_entity.data IS 'A collection of data to cache.';


--
-- Name: COLUMN cache_entity.expire; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_entity.expire IS 'A Unix timestamp indicating when the cache entry should expire, or -1 for never.';


--
-- Name: COLUMN cache_entity.created; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_entity.created IS 'A timestamp with millisecond precision indicating when the cache entry was created.';


--
-- Name: COLUMN cache_entity.serialized; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_entity.serialized IS 'A flag to indicate whether content is serialized (1) or not (0).';


--
-- Name: COLUMN cache_entity.tags; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_entity.tags IS 'Space-separated list of cache tags for this entry.';


--
-- Name: COLUMN cache_entity.checksum; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_entity.checksum IS 'The tag invalidation checksum when this entry was saved.';


--
-- Name: cache_file_parsing; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.cache_file_parsing (
    cid character varying(255) DEFAULT ''::character varying NOT NULL,
    data bytea,
    expire bigint DEFAULT 0 NOT NULL,
    created numeric(14,3) DEFAULT 0 NOT NULL,
    serialized smallint DEFAULT 0 NOT NULL,
    tags text,
    checksum character varying(255) NOT NULL
);


ALTER TABLE public.cache_file_parsing OWNER TO root;

--
-- Name: TABLE cache_file_parsing; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.cache_file_parsing IS 'Storage for the cache API.';


--
-- Name: COLUMN cache_file_parsing.cid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_file_parsing.cid IS 'Primary Key: Unique cache ID.';


--
-- Name: COLUMN cache_file_parsing.data; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_file_parsing.data IS 'A collection of data to cache.';


--
-- Name: COLUMN cache_file_parsing.expire; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_file_parsing.expire IS 'A Unix timestamp indicating when the cache entry should expire, or -1 for never.';


--
-- Name: COLUMN cache_file_parsing.created; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_file_parsing.created IS 'A timestamp with millisecond precision indicating when the cache entry was created.';


--
-- Name: COLUMN cache_file_parsing.serialized; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_file_parsing.serialized IS 'A flag to indicate whether content is serialized (1) or not (0).';


--
-- Name: COLUMN cache_file_parsing.tags; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_file_parsing.tags IS 'Space-separated list of cache tags for this entry.';


--
-- Name: COLUMN cache_file_parsing.checksum; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_file_parsing.checksum IS 'The tag invalidation checksum when this entry was saved.';


--
-- Name: cache_menu; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.cache_menu (
    cid character varying(255) DEFAULT ''::character varying NOT NULL,
    data bytea,
    expire bigint DEFAULT 0 NOT NULL,
    created numeric(14,3) DEFAULT 0 NOT NULL,
    serialized smallint DEFAULT 0 NOT NULL,
    tags text,
    checksum character varying(255) NOT NULL
);


ALTER TABLE public.cache_menu OWNER TO root;

--
-- Name: TABLE cache_menu; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.cache_menu IS 'Storage for the cache API.';


--
-- Name: COLUMN cache_menu.cid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_menu.cid IS 'Primary Key: Unique cache ID.';


--
-- Name: COLUMN cache_menu.data; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_menu.data IS 'A collection of data to cache.';


--
-- Name: COLUMN cache_menu.expire; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_menu.expire IS 'A Unix timestamp indicating when the cache entry should expire, or -1 for never.';


--
-- Name: COLUMN cache_menu.created; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_menu.created IS 'A timestamp with millisecond precision indicating when the cache entry was created.';


--
-- Name: COLUMN cache_menu.serialized; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_menu.serialized IS 'A flag to indicate whether content is serialized (1) or not (0).';


--
-- Name: COLUMN cache_menu.tags; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_menu.tags IS 'Space-separated list of cache tags for this entry.';


--
-- Name: COLUMN cache_menu.checksum; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_menu.checksum IS 'The tag invalidation checksum when this entry was saved.';


--
-- Name: cache_render; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.cache_render (
    cid character varying(255) DEFAULT ''::character varying NOT NULL,
    data bytea,
    expire bigint DEFAULT 0 NOT NULL,
    created numeric(14,3) DEFAULT 0 NOT NULL,
    serialized smallint DEFAULT 0 NOT NULL,
    tags text,
    checksum character varying(255) NOT NULL
);


ALTER TABLE public.cache_render OWNER TO root;

--
-- Name: TABLE cache_render; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.cache_render IS 'Storage for the cache API.';


--
-- Name: COLUMN cache_render.cid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_render.cid IS 'Primary Key: Unique cache ID.';


--
-- Name: COLUMN cache_render.data; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_render.data IS 'A collection of data to cache.';


--
-- Name: COLUMN cache_render.expire; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_render.expire IS 'A Unix timestamp indicating when the cache entry should expire, or -1 for never.';


--
-- Name: COLUMN cache_render.created; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_render.created IS 'A timestamp with millisecond precision indicating when the cache entry was created.';


--
-- Name: COLUMN cache_render.serialized; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_render.serialized IS 'A flag to indicate whether content is serialized (1) or not (0).';


--
-- Name: COLUMN cache_render.tags; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_render.tags IS 'Space-separated list of cache tags for this entry.';


--
-- Name: COLUMN cache_render.checksum; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_render.checksum IS 'The tag invalidation checksum when this entry was saved.';


--
-- Name: cache_routes; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.cache_routes (
    cid character varying(255) DEFAULT ''::character varying NOT NULL,
    data bytea,
    expire bigint DEFAULT 0 NOT NULL,
    created numeric(14,3) DEFAULT 0 NOT NULL,
    serialized smallint DEFAULT 0 NOT NULL,
    tags text,
    checksum character varying(255) NOT NULL
);


ALTER TABLE public.cache_routes OWNER TO root;

--
-- Name: TABLE cache_routes; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.cache_routes IS 'Storage for the cache API.';


--
-- Name: COLUMN cache_routes.cid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_routes.cid IS 'Primary Key: Unique cache ID.';


--
-- Name: COLUMN cache_routes.data; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_routes.data IS 'A collection of data to cache.';


--
-- Name: COLUMN cache_routes.expire; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_routes.expire IS 'A Unix timestamp indicating when the cache entry should expire, or -1 for never.';


--
-- Name: COLUMN cache_routes.created; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_routes.created IS 'A timestamp with millisecond precision indicating when the cache entry was created.';


--
-- Name: COLUMN cache_routes.serialized; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_routes.serialized IS 'A flag to indicate whether content is serialized (1) or not (0).';


--
-- Name: COLUMN cache_routes.tags; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_routes.tags IS 'Space-separated list of cache tags for this entry.';


--
-- Name: COLUMN cache_routes.checksum; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cache_routes.checksum IS 'The tag invalidation checksum when this entry was saved.';


--
-- Name: cachetags; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.cachetags (
    tag character varying(255) DEFAULT ''::character varying NOT NULL,
    invalidations integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.cachetags OWNER TO root;

--
-- Name: TABLE cachetags; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.cachetags IS 'Cache table for tracking cache tag invalidations.';


--
-- Name: COLUMN cachetags.tag; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cachetags.tag IS 'Namespace-prefixed tag string.';


--
-- Name: COLUMN cachetags.invalidations; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.cachetags.invalidations IS 'Number incremented when the tag is invalidated.';


--
-- Name: config; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.config (
    collection character varying(255) DEFAULT ''::character varying NOT NULL,
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    data bytea
);


ALTER TABLE public.config OWNER TO root;

--
-- Name: TABLE config; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.config IS 'The base table for configuration data.';


--
-- Name: COLUMN config.collection; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.config.collection IS 'Primary Key: Config object collection.';


--
-- Name: COLUMN config.name; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.config.name IS 'Primary Key: Config object name.';


--
-- Name: COLUMN config.data; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.config.data IS 'A serialized configuration object data.';


--
-- Name: file_managed; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.file_managed (
    fid integer NOT NULL,
    uuid character varying(128) NOT NULL,
    langcode character varying(12) NOT NULL,
    uid bigint,
    filename character varying(255),
    uri character varying(255) NOT NULL,
    filemime character varying(255),
    filesize bigint,
    status smallint NOT NULL,
    created integer,
    changed integer NOT NULL,
    CONSTRAINT file_managed_fid_check CHECK ((fid >= 0)),
    CONSTRAINT file_managed_filesize_check CHECK ((filesize >= 0)),
    CONSTRAINT file_managed_uid_check CHECK ((uid >= 0))
);


ALTER TABLE public.file_managed OWNER TO root;

--
-- Name: TABLE file_managed; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.file_managed IS 'The base table for file entities.';


--
-- Name: COLUMN file_managed.uid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.file_managed.uid IS 'The ID of the target entity.';


--
-- Name: file_managed_fid_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.file_managed_fid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.file_managed_fid_seq OWNER TO root;

--
-- Name: file_managed_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.file_managed_fid_seq OWNED BY public.file_managed.fid;


--
-- Name: file_usage; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.file_usage (
    fid bigint NOT NULL,
    module character varying(50) DEFAULT ''::character varying NOT NULL,
    type character varying(64) DEFAULT ''::character varying NOT NULL,
    id character varying(64) DEFAULT 0 NOT NULL,
    count bigint DEFAULT 0 NOT NULL,
    CONSTRAINT file_usage_count_check CHECK ((count >= 0)),
    CONSTRAINT file_usage_fid_check CHECK ((fid >= 0))
);


ALTER TABLE public.file_usage OWNER TO root;

--
-- Name: TABLE file_usage; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.file_usage IS 'Track where a file is used.';


--
-- Name: COLUMN file_usage.fid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.file_usage.fid IS 'File ID.';


--
-- Name: COLUMN file_usage.module; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.file_usage.module IS 'The name of the module that is using the file.';


--
-- Name: COLUMN file_usage.type; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.file_usage.type IS 'The name of the object type in which the file is used.';


--
-- Name: COLUMN file_usage.id; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.file_usage.id IS 'The primary key of the object using the file.';


--
-- Name: COLUMN file_usage.count; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.file_usage.count IS 'The number of times this file is used by this object.';


--
-- Name: inline_block_usage; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.inline_block_usage (
    block_content_id bigint NOT NULL,
    layout_entity_type character varying(32) DEFAULT ''::character varying,
    layout_entity_id character varying(128) DEFAULT 0,
    CONSTRAINT inline_block_usage_block_content_id_check CHECK ((block_content_id >= 0))
);


ALTER TABLE public.inline_block_usage OWNER TO root;

--
-- Name: TABLE inline_block_usage; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.inline_block_usage IS 'Track where a block_content entity is used.';


--
-- Name: COLUMN inline_block_usage.block_content_id; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.inline_block_usage.block_content_id IS 'The block_content entity ID.';


--
-- Name: COLUMN inline_block_usage.layout_entity_type; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.inline_block_usage.layout_entity_type IS 'The entity type of the parent entity.';


--
-- Name: COLUMN inline_block_usage.layout_entity_id; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.inline_block_usage.layout_entity_id IS 'The ID of the parent entity.';


--
-- Name: key_value; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.key_value (
    collection character varying(128) DEFAULT ''::character varying NOT NULL,
    name character varying(128) DEFAULT ''::character varying NOT NULL,
    value bytea NOT NULL
);


ALTER TABLE public.key_value OWNER TO root;

--
-- Name: TABLE key_value; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.key_value IS 'Generic key-value storage table. See the state system for an example.';


--
-- Name: COLUMN key_value.collection; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.key_value.collection IS 'A named collection of key and value pairs.';


--
-- Name: COLUMN key_value.name; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.key_value.name IS 'The key of the key-value pair. As KEY is a SQL reserved keyword, name was chosen instead.';


--
-- Name: COLUMN key_value.value; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.key_value.value IS 'The value.';


--
-- Name: key_value_expire; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.key_value_expire (
    collection character varying(128) DEFAULT ''::character varying NOT NULL,
    name character varying(128) DEFAULT ''::character varying NOT NULL,
    value bytea NOT NULL,
    expire integer DEFAULT 2147483647 NOT NULL
);


ALTER TABLE public.key_value_expire OWNER TO root;

--
-- Name: TABLE key_value_expire; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.key_value_expire IS 'Generic key/value storage table with an expiration.';


--
-- Name: COLUMN key_value_expire.collection; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.key_value_expire.collection IS 'A named collection of key and value pairs.';


--
-- Name: COLUMN key_value_expire.name; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.key_value_expire.name IS 'The key of the key/value pair.';


--
-- Name: COLUMN key_value_expire.value; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.key_value_expire.value IS 'The value of the key/value pair.';


--
-- Name: COLUMN key_value_expire.expire; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.key_value_expire.expire IS 'The time since Unix epoch in seconds when this item expires. Defaults to the maximum possible time.';


--
-- Name: menu_link_content; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.menu_link_content (
    id integer NOT NULL,
    revision_id bigint,
    bundle character varying(32) NOT NULL,
    uuid character varying(128) NOT NULL,
    langcode character varying(12) NOT NULL,
    CONSTRAINT menu_link_content_id_check CHECK ((id >= 0)),
    CONSTRAINT menu_link_content_revision_id_check CHECK ((revision_id >= 0))
);


ALTER TABLE public.menu_link_content OWNER TO root;

--
-- Name: TABLE menu_link_content; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.menu_link_content IS 'The base table for menu_link_content entities.';


--
-- Name: menu_link_content_data; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.menu_link_content_data (
    id bigint NOT NULL,
    revision_id bigint NOT NULL,
    bundle character varying(32) NOT NULL,
    langcode character varying(12) NOT NULL,
    enabled smallint NOT NULL,
    title character varying(255),
    description character varying(255),
    menu_name character varying(255),
    link__uri character varying(2048),
    link__title character varying(255),
    link__options bytea,
    external smallint,
    rediscover smallint,
    weight integer,
    expanded smallint,
    parent character varying(255),
    changed integer,
    default_langcode smallint NOT NULL,
    revision_translation_affected smallint,
    CONSTRAINT menu_link_content_data_id_check CHECK ((id >= 0)),
    CONSTRAINT menu_link_content_data_revision_id_check CHECK ((revision_id >= 0))
);


ALTER TABLE public.menu_link_content_data OWNER TO root;

--
-- Name: TABLE menu_link_content_data; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.menu_link_content_data IS 'The data table for menu_link_content entities.';


--
-- Name: COLUMN menu_link_content_data.link__uri; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_link_content_data.link__uri IS 'The URI of the link.';


--
-- Name: COLUMN menu_link_content_data.link__title; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_link_content_data.link__title IS 'The link text.';


--
-- Name: COLUMN menu_link_content_data.link__options; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_link_content_data.link__options IS 'Serialized array of options for the link.';


--
-- Name: menu_link_content_field_revision; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.menu_link_content_field_revision (
    id bigint NOT NULL,
    revision_id bigint NOT NULL,
    langcode character varying(12) NOT NULL,
    enabled smallint NOT NULL,
    title character varying(255),
    description character varying(255),
    link__uri character varying(2048),
    link__title character varying(255),
    link__options bytea,
    external smallint,
    changed integer,
    default_langcode smallint NOT NULL,
    revision_translation_affected smallint,
    CONSTRAINT menu_link_content_field_revision_id_check CHECK ((id >= 0)),
    CONSTRAINT menu_link_content_field_revision_revision_id_check CHECK ((revision_id >= 0))
);


ALTER TABLE public.menu_link_content_field_revision OWNER TO root;

--
-- Name: TABLE menu_link_content_field_revision; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.menu_link_content_field_revision IS 'The revision data table for menu_link_content entities.';


--
-- Name: COLUMN menu_link_content_field_revision.link__uri; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_link_content_field_revision.link__uri IS 'The URI of the link.';


--
-- Name: COLUMN menu_link_content_field_revision.link__title; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_link_content_field_revision.link__title IS 'The link text.';


--
-- Name: COLUMN menu_link_content_field_revision.link__options; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_link_content_field_revision.link__options IS 'Serialized array of options for the link.';


--
-- Name: menu_link_content_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.menu_link_content_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.menu_link_content_id_seq OWNER TO root;

--
-- Name: menu_link_content_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.menu_link_content_id_seq OWNED BY public.menu_link_content.id;


--
-- Name: menu_link_content_revision; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.menu_link_content_revision (
    id bigint NOT NULL,
    revision_id integer NOT NULL,
    langcode character varying(12) NOT NULL,
    revision_user bigint,
    revision_created integer,
    revision_log_message text,
    revision_default smallint,
    CONSTRAINT menu_link_content_revision_id_check1 CHECK ((id >= 0)),
    CONSTRAINT menu_link_content_revision_revision_id_check CHECK ((revision_id >= 0)),
    CONSTRAINT menu_link_content_revision_revision_user_check CHECK ((revision_user >= 0))
);


ALTER TABLE public.menu_link_content_revision OWNER TO root;

--
-- Name: TABLE menu_link_content_revision; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.menu_link_content_revision IS 'The revision table for menu_link_content entities.';


--
-- Name: COLUMN menu_link_content_revision.revision_user; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_link_content_revision.revision_user IS 'The ID of the target entity.';


--
-- Name: menu_link_content_revision_revision_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.menu_link_content_revision_revision_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.menu_link_content_revision_revision_id_seq OWNER TO root;

--
-- Name: menu_link_content_revision_revision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.menu_link_content_revision_revision_id_seq OWNED BY public.menu_link_content_revision.revision_id;


--
-- Name: menu_tree; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.menu_tree (
    menu_name character varying(32) DEFAULT ''::character varying NOT NULL,
    mlid integer NOT NULL,
    id character varying(255) NOT NULL,
    parent character varying(255) DEFAULT ''::character varying NOT NULL,
    route_name character varying(255),
    route_param_key character varying(2048),
    route_parameters bytea,
    url character varying(2048) DEFAULT ''::character varying NOT NULL,
    title bytea,
    description bytea,
    class text,
    options bytea,
    provider character varying(50) DEFAULT 'system'::character varying NOT NULL,
    enabled smallint DEFAULT 1 NOT NULL,
    discovered smallint DEFAULT 0 NOT NULL,
    expanded smallint DEFAULT 0 NOT NULL,
    weight integer DEFAULT 0 NOT NULL,
    metadata bytea,
    has_children smallint DEFAULT 0 NOT NULL,
    depth smallint DEFAULT 0 NOT NULL,
    p1 bigint DEFAULT 0 NOT NULL,
    p2 bigint DEFAULT 0 NOT NULL,
    p3 bigint DEFAULT 0 NOT NULL,
    p4 bigint DEFAULT 0 NOT NULL,
    p5 bigint DEFAULT 0 NOT NULL,
    p6 bigint DEFAULT 0 NOT NULL,
    p7 bigint DEFAULT 0 NOT NULL,
    p8 bigint DEFAULT 0 NOT NULL,
    p9 bigint DEFAULT 0 NOT NULL,
    form_class character varying(255),
    CONSTRAINT menu_tree_mlid_check CHECK ((mlid >= 0)),
    CONSTRAINT menu_tree_p1_check CHECK ((p1 >= 0)),
    CONSTRAINT menu_tree_p2_check CHECK ((p2 >= 0)),
    CONSTRAINT menu_tree_p3_check CHECK ((p3 >= 0)),
    CONSTRAINT menu_tree_p4_check CHECK ((p4 >= 0)),
    CONSTRAINT menu_tree_p5_check CHECK ((p5 >= 0)),
    CONSTRAINT menu_tree_p6_check CHECK ((p6 >= 0)),
    CONSTRAINT menu_tree_p7_check CHECK ((p7 >= 0)),
    CONSTRAINT menu_tree_p8_check CHECK ((p8 >= 0)),
    CONSTRAINT menu_tree_p9_check CHECK ((p9 >= 0))
);


ALTER TABLE public.menu_tree OWNER TO root;

--
-- Name: TABLE menu_tree; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.menu_tree IS 'Contains the menu tree hierarchy.';


--
-- Name: COLUMN menu_tree.menu_name; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.menu_name IS 'The menu name. All links with the same menu name (such as ''tools'') are part of the same menu.';


--
-- Name: COLUMN menu_tree.mlid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.mlid IS 'The menu link ID (mlid) is the integer primary key.';


--
-- Name: COLUMN menu_tree.id; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.id IS 'Unique machine name: the plugin ID.';


--
-- Name: COLUMN menu_tree.parent; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.parent IS 'The plugin ID for the parent of this link.';


--
-- Name: COLUMN menu_tree.route_name; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.route_name IS 'The machine name of a defined Symfony Route this menu link represents.';


--
-- Name: COLUMN menu_tree.route_param_key; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.route_param_key IS 'An encoded string of route parameters for loading by route.';


--
-- Name: COLUMN menu_tree.route_parameters; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.route_parameters IS 'Serialized array of route parameters of this menu link.';


--
-- Name: COLUMN menu_tree.url; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.url IS 'The external path this link points to (when not using a route).';


--
-- Name: COLUMN menu_tree.title; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.title IS 'The serialized title for the link. May be a TranslatableMarkup.';


--
-- Name: COLUMN menu_tree.description; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.description IS 'The serialized description of this link - used for admin pages and title attribute. May be a TranslatableMarkup.';


--
-- Name: COLUMN menu_tree.class; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.class IS 'The class for this link plugin.';


--
-- Name: COLUMN menu_tree.options; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.options IS 'A serialized array of URL options, such as a query string or HTML attributes.';


--
-- Name: COLUMN menu_tree.provider; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.provider IS 'The name of the module that generated this link.';


--
-- Name: COLUMN menu_tree.enabled; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.enabled IS 'A flag for whether the link should be rendered in menus. (0 = a disabled menu link that may be shown on admin screens, 1 = a normal, visible link)';


--
-- Name: COLUMN menu_tree.discovered; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.discovered IS 'A flag for whether the link was discovered, so can be purged on rebuild';


--
-- Name: COLUMN menu_tree.expanded; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.expanded IS 'Flag for whether this link should be rendered as expanded in menus - expanded links always have their child links displayed, instead of only when the link is in the active trail (1 = expanded, 0 = not expanded)';


--
-- Name: COLUMN menu_tree.weight; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.weight IS 'Link weight among links in the same menu at the same depth.';


--
-- Name: COLUMN menu_tree.metadata; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.metadata IS 'A serialized array of data that may be used by the plugin instance.';


--
-- Name: COLUMN menu_tree.has_children; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.has_children IS 'Flag indicating whether any enabled links have this link as a parent (1 = enabled children exist, 0 = no enabled children).';


--
-- Name: COLUMN menu_tree.depth; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.depth IS 'The depth relative to the top level. A link with empty parent will have depth == 1.';


--
-- Name: COLUMN menu_tree.p1; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.p1 IS 'The first mlid in the materialized path. If N = depth, then pN must equal the mlid. If depth > 1 then p(N-1) must equal the parent link mlid. All pX where X > depth must equal zero. The columns p1 .. p9 are also called the parents.';


--
-- Name: COLUMN menu_tree.p2; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.p2 IS 'The second mlid in the materialized path. See p1.';


--
-- Name: COLUMN menu_tree.p3; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.p3 IS 'The third mlid in the materialized path. See p1.';


--
-- Name: COLUMN menu_tree.p4; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.p4 IS 'The fourth mlid in the materialized path. See p1.';


--
-- Name: COLUMN menu_tree.p5; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.p5 IS 'The fifth mlid in the materialized path. See p1.';


--
-- Name: COLUMN menu_tree.p6; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.p6 IS 'The sixth mlid in the materialized path. See p1.';


--
-- Name: COLUMN menu_tree.p7; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.p7 IS 'The seventh mlid in the materialized path. See p1.';


--
-- Name: COLUMN menu_tree.p8; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.p8 IS 'The eighth mlid in the materialized path. See p1.';


--
-- Name: COLUMN menu_tree.p9; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.p9 IS 'The ninth mlid in the materialized path. See p1.';


--
-- Name: COLUMN menu_tree.form_class; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.menu_tree.form_class IS 'meh';


--
-- Name: menu_tree_mlid_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.menu_tree_mlid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.menu_tree_mlid_seq OWNER TO root;

--
-- Name: menu_tree_mlid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.menu_tree_mlid_seq OWNED BY public.menu_tree.mlid;


--
-- Name: node; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.node (
    nid integer NOT NULL,
    vid bigint,
    type character varying(32) NOT NULL,
    uuid character varying(128) NOT NULL,
    langcode character varying(12) NOT NULL,
    CONSTRAINT node_nid_check CHECK ((nid >= 0)),
    CONSTRAINT node_vid_check CHECK ((vid >= 0))
);


ALTER TABLE public.node OWNER TO root;

--
-- Name: TABLE node; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.node IS 'The base table for node entities.';


--
-- Name: COLUMN node.type; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.node.type IS 'The ID of the target entity.';


--
-- Name: node_access; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.node_access (
    nid bigint DEFAULT 0 NOT NULL,
    langcode character varying(12) DEFAULT ''::character varying NOT NULL,
    fallback integer DEFAULT 1 NOT NULL,
    gid bigint DEFAULT 0 NOT NULL,
    realm character varying(255) DEFAULT ''::character varying NOT NULL,
    grant_view integer DEFAULT 0 NOT NULL,
    grant_update integer DEFAULT 0 NOT NULL,
    grant_delete integer DEFAULT 0 NOT NULL,
    CONSTRAINT node_access_fallback_check CHECK ((fallback >= 0)),
    CONSTRAINT node_access_gid_check CHECK ((gid >= 0)),
    CONSTRAINT node_access_grant_delete_check CHECK ((grant_delete >= 0)),
    CONSTRAINT node_access_grant_update_check CHECK ((grant_update >= 0)),
    CONSTRAINT node_access_grant_view_check CHECK ((grant_view >= 0)),
    CONSTRAINT node_access_nid_check CHECK ((nid >= 0))
);


ALTER TABLE public.node_access OWNER TO root;

--
-- Name: TABLE node_access; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.node_access IS 'Identifies which realm/grant pairs a user must possess in order to view, update, or delete specific nodes.';


--
-- Name: COLUMN node_access.nid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.node_access.nid IS 'The "node".nid this record affects.';


--
-- Name: COLUMN node_access.langcode; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.node_access.langcode IS 'The "language".langcode of this node.';


--
-- Name: COLUMN node_access.fallback; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.node_access.fallback IS 'Boolean indicating whether this record should be used as a fallback if a language condition is not provided.';


--
-- Name: COLUMN node_access.gid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.node_access.gid IS 'The grant ID a user must possess in the specified realm to gain this row''s privileges on the node.';


--
-- Name: COLUMN node_access.realm; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.node_access.realm IS 'The realm in which the user must possess the grant ID. Modules can define one or more realms by implementing hook_node_grants().';


--
-- Name: COLUMN node_access.grant_view; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.node_access.grant_view IS 'Boolean indicating whether a user with the realm/grant pair can view this node.';


--
-- Name: COLUMN node_access.grant_update; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.node_access.grant_update IS 'Boolean indicating whether a user with the realm/grant pair can edit this node.';


--
-- Name: COLUMN node_access.grant_delete; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.node_access.grant_delete IS 'Boolean indicating whether a user with the realm/grant pair can delete this node.';


--
-- Name: node_field_data; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.node_field_data (
    nid bigint NOT NULL,
    vid bigint NOT NULL,
    type character varying(32) NOT NULL,
    langcode character varying(12) NOT NULL,
    status smallint NOT NULL,
    uid bigint NOT NULL,
    title character varying(255) NOT NULL,
    created integer NOT NULL,
    changed integer NOT NULL,
    promote smallint NOT NULL,
    sticky smallint NOT NULL,
    default_langcode smallint NOT NULL,
    revision_translation_affected smallint,
    CONSTRAINT node_field_data_nid_check CHECK ((nid >= 0)),
    CONSTRAINT node_field_data_uid_check CHECK ((uid >= 0)),
    CONSTRAINT node_field_data_vid_check CHECK ((vid >= 0))
);


ALTER TABLE public.node_field_data OWNER TO root;

--
-- Name: TABLE node_field_data; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.node_field_data IS 'The data table for node entities.';


--
-- Name: COLUMN node_field_data.type; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.node_field_data.type IS 'The ID of the target entity.';


--
-- Name: COLUMN node_field_data.uid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.node_field_data.uid IS 'The ID of the target entity.';


--
-- Name: node_field_revision; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.node_field_revision (
    nid bigint NOT NULL,
    vid bigint NOT NULL,
    langcode character varying(12) NOT NULL,
    status smallint NOT NULL,
    uid bigint NOT NULL,
    title character varying(255),
    created integer,
    changed integer,
    promote smallint,
    sticky smallint,
    default_langcode smallint NOT NULL,
    revision_translation_affected smallint,
    CONSTRAINT node_field_revision_nid_check CHECK ((nid >= 0)),
    CONSTRAINT node_field_revision_uid_check CHECK ((uid >= 0)),
    CONSTRAINT node_field_revision_vid_check CHECK ((vid >= 0))
);


ALTER TABLE public.node_field_revision OWNER TO root;

--
-- Name: TABLE node_field_revision; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.node_field_revision IS 'The revision data table for node entities.';


--
-- Name: COLUMN node_field_revision.uid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.node_field_revision.uid IS 'The ID of the target entity.';


--
-- Name: node_nid_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.node_nid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.node_nid_seq OWNER TO root;

--
-- Name: node_nid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.node_nid_seq OWNED BY public.node.nid;


--
-- Name: node_revision; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.node_revision (
    nid bigint NOT NULL,
    vid integer NOT NULL,
    langcode character varying(12) NOT NULL,
    revision_uid bigint,
    revision_timestamp integer,
    revision_log text,
    revision_default smallint,
    CONSTRAINT node_revision_nid_check CHECK ((nid >= 0)),
    CONSTRAINT node_revision_revision_uid_check CHECK ((revision_uid >= 0)),
    CONSTRAINT node_revision_vid_check CHECK ((vid >= 0))
);


ALTER TABLE public.node_revision OWNER TO root;

--
-- Name: TABLE node_revision; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.node_revision IS 'The revision table for node entities.';


--
-- Name: COLUMN node_revision.revision_uid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.node_revision.revision_uid IS 'The ID of the target entity.';


--
-- Name: node_revision_vid_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.node_revision_vid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.node_revision_vid_seq OWNER TO root;

--
-- Name: node_revision_vid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.node_revision_vid_seq OWNED BY public.node_revision.vid;


--
-- Name: path_alias; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.path_alias (
    id integer NOT NULL,
    revision_id bigint,
    uuid character varying(128) NOT NULL,
    langcode character varying(12) NOT NULL,
    path character varying(255),
    alias character varying(255),
    status smallint NOT NULL,
    CONSTRAINT path_alias_id_check CHECK ((id >= 0)),
    CONSTRAINT path_alias_revision_id_check CHECK ((revision_id >= 0))
);


ALTER TABLE public.path_alias OWNER TO root;

--
-- Name: TABLE path_alias; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.path_alias IS 'The base table for path_alias entities.';


--
-- Name: path_alias_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.path_alias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.path_alias_id_seq OWNER TO root;

--
-- Name: path_alias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.path_alias_id_seq OWNED BY public.path_alias.id;


--
-- Name: path_alias_revision; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.path_alias_revision (
    id bigint NOT NULL,
    revision_id integer NOT NULL,
    langcode character varying(12) NOT NULL,
    path character varying(255),
    alias character varying(255),
    status smallint NOT NULL,
    revision_default smallint,
    CONSTRAINT path_alias_revision_id_check1 CHECK ((id >= 0)),
    CONSTRAINT path_alias_revision_revision_id_check CHECK ((revision_id >= 0))
);


ALTER TABLE public.path_alias_revision OWNER TO root;

--
-- Name: TABLE path_alias_revision; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.path_alias_revision IS 'The revision table for path_alias entities.';


--
-- Name: path_alias_revision_revision_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.path_alias_revision_revision_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.path_alias_revision_revision_id_seq OWNER TO root;

--
-- Name: path_alias_revision_revision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.path_alias_revision_revision_id_seq OWNED BY public.path_alias_revision.revision_id;


--
-- Name: queue; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.queue (
    item_id integer NOT NULL,
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    data bytea,
    expire bigint DEFAULT 0 NOT NULL,
    created bigint DEFAULT 0 NOT NULL,
    CONSTRAINT queue_item_id_check CHECK ((item_id >= 0))
);


ALTER TABLE public.queue OWNER TO root;

--
-- Name: TABLE queue; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.queue IS 'Stores items in queues.';


--
-- Name: COLUMN queue.item_id; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.queue.item_id IS 'Primary Key: Unique item ID.';


--
-- Name: COLUMN queue.name; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.queue.name IS 'The queue name.';


--
-- Name: COLUMN queue.data; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.queue.data IS 'The arbitrary data for the item.';


--
-- Name: COLUMN queue.expire; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.queue.expire IS 'Timestamp when the claim lease expires on the item.';


--
-- Name: COLUMN queue.created; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.queue.created IS 'Timestamp when the item was created.';


--
-- Name: queue_item_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.queue_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.queue_item_id_seq OWNER TO root;

--
-- Name: queue_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.queue_item_id_seq OWNED BY public.queue.item_id;


--
-- Name: router; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.router (
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    path character varying(255) DEFAULT ''::character varying NOT NULL,
    pattern_outline character varying(255) DEFAULT ''::character varying NOT NULL,
    fit integer DEFAULT 0 NOT NULL,
    route bytea,
    number_parts smallint DEFAULT 0 NOT NULL,
    alias character varying(255)
);


ALTER TABLE public.router OWNER TO root;

--
-- Name: TABLE router; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.router IS 'Maps paths to various callbacks (access, page and title)';


--
-- Name: COLUMN router.name; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.router.name IS 'Primary Key: Machine name of this route';


--
-- Name: COLUMN router.path; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.router.path IS 'The path for this URI';


--
-- Name: COLUMN router.pattern_outline; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.router.pattern_outline IS 'The pattern';


--
-- Name: COLUMN router.fit; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.router.fit IS 'A numeric representation of how specific the path is.';


--
-- Name: COLUMN router.route; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.router.route IS 'A serialized Route object';


--
-- Name: COLUMN router.number_parts; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.router.number_parts IS 'Number of parts in this router path.';


--
-- Name: COLUMN router.alias; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.router.alias IS 'The alias of the route, if applicable.';


--
-- Name: semaphore; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.semaphore (
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    value character varying(255) DEFAULT ''::character varying NOT NULL,
    expire double precision NOT NULL
);


ALTER TABLE public.semaphore OWNER TO root;

--
-- Name: TABLE semaphore; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.semaphore IS 'Table for holding semaphores, locks, flags, etc. that cannot be stored as state since they must not be cached.';


--
-- Name: COLUMN semaphore.name; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.semaphore.name IS 'Primary Key: Unique name.';


--
-- Name: COLUMN semaphore.value; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.semaphore.value IS 'A value for the semaphore.';


--
-- Name: COLUMN semaphore.expire; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.semaphore.expire IS 'A Unix timestamp with microseconds indicating when the semaphore should expire.';


--
-- Name: sequences; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.sequences (
    value integer NOT NULL,
    CONSTRAINT sequences_value_check CHECK ((value >= 0))
);


ALTER TABLE public.sequences OWNER TO root;

--
-- Name: TABLE sequences; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.sequences IS 'Stores IDs.';


--
-- Name: COLUMN sequences.value; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.sequences.value IS 'The value of the sequence.';


--
-- Name: sequences_value_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.sequences_value_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sequences_value_seq OWNER TO root;

--
-- Name: sequences_value_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.sequences_value_seq OWNED BY public.sequences.value;


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.sessions (
    uid bigint NOT NULL,
    sid character varying(128) NOT NULL,
    hostname character varying(128) DEFAULT ''::character varying NOT NULL,
    "timestamp" bigint DEFAULT 0 NOT NULL,
    session bytea,
    CONSTRAINT sessions_uid_check CHECK ((uid >= 0))
);


ALTER TABLE public.sessions OWNER TO root;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.sessions IS 'Drupal''s session handlers read and write into the sessions table. Each record represents a user session, either anonymous or authenticated.';


--
-- Name: COLUMN sessions.uid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.sessions.uid IS 'The "users".uid corresponding to a session, or 0 for anonymous user.';


--
-- Name: COLUMN sessions.sid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.sessions.sid IS 'A session ID (hashed). The value is generated by Drupal''s session handlers.';


--
-- Name: COLUMN sessions.hostname; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.sessions.hostname IS 'The IP address that last used this session ID (sid).';


--
-- Name: COLUMN sessions."timestamp"; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.sessions."timestamp" IS 'The Unix timestamp when this session last requested a page. Old records are purged by PHP automatically.';


--
-- Name: COLUMN sessions.session; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.sessions.session IS 'The serialized contents of the user''s session, an array of name/value pairs that persists across page requests by this session ID. Drupal loads the user''s session from here   at the start of each request and saves it at the end.';


--
-- Name: taxonomy_index; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.taxonomy_index (
    nid bigint DEFAULT 0 NOT NULL,
    tid bigint DEFAULT 0 NOT NULL,
    status integer DEFAULT 1 NOT NULL,
    sticky smallint DEFAULT 0,
    created integer DEFAULT 0 NOT NULL,
    CONSTRAINT taxonomy_index_nid_check CHECK ((nid >= 0)),
    CONSTRAINT taxonomy_index_tid_check CHECK ((tid >= 0))
);


ALTER TABLE public.taxonomy_index OWNER TO root;

--
-- Name: TABLE taxonomy_index; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.taxonomy_index IS 'Maintains denormalized information about node/term relationships.';


--
-- Name: COLUMN taxonomy_index.nid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.taxonomy_index.nid IS 'The "node".nid this record tracks.';


--
-- Name: COLUMN taxonomy_index.tid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.taxonomy_index.tid IS 'The term ID.';


--
-- Name: COLUMN taxonomy_index.status; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.taxonomy_index.status IS 'Boolean indicating whether the node is published (visible to non-administrators).';


--
-- Name: COLUMN taxonomy_index.sticky; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.taxonomy_index.sticky IS 'Boolean indicating whether the node is sticky.';


--
-- Name: COLUMN taxonomy_index.created; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.taxonomy_index.created IS 'The Unix timestamp when the node was created.';


--
-- Name: taxonomy_term__parent; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.taxonomy_term__parent (
    bundle character varying(128) DEFAULT ''::character varying NOT NULL,
    deleted smallint DEFAULT 0 NOT NULL,
    entity_id bigint NOT NULL,
    revision_id bigint NOT NULL,
    langcode character varying(32) DEFAULT ''::character varying NOT NULL,
    delta bigint NOT NULL,
    parent_target_id bigint NOT NULL,
    CONSTRAINT taxonomy_term__parent_delta_check CHECK ((delta >= 0)),
    CONSTRAINT taxonomy_term__parent_entity_id_check CHECK ((entity_id >= 0)),
    CONSTRAINT taxonomy_term__parent_parent_target_id_check CHECK ((parent_target_id >= 0)),
    CONSTRAINT taxonomy_term__parent_revision_id_check CHECK ((revision_id >= 0))
);


ALTER TABLE public.taxonomy_term__parent OWNER TO root;

--
-- Name: TABLE taxonomy_term__parent; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.taxonomy_term__parent IS 'Data storage for taxonomy_term field parent.';


--
-- Name: COLUMN taxonomy_term__parent.bundle; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.taxonomy_term__parent.bundle IS 'The field instance bundle to which this row belongs, used when deleting a field instance';


--
-- Name: COLUMN taxonomy_term__parent.deleted; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.taxonomy_term__parent.deleted IS 'A boolean indicating whether this data item has been deleted';


--
-- Name: COLUMN taxonomy_term__parent.entity_id; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.taxonomy_term__parent.entity_id IS 'The entity id this data is attached to';


--
-- Name: COLUMN taxonomy_term__parent.revision_id; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.taxonomy_term__parent.revision_id IS 'The entity revision id this data is attached to';


--
-- Name: COLUMN taxonomy_term__parent.langcode; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.taxonomy_term__parent.langcode IS 'The language code for this data item.';


--
-- Name: COLUMN taxonomy_term__parent.delta; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.taxonomy_term__parent.delta IS 'The sequence number for this data item, used for multi-value fields';


--
-- Name: COLUMN taxonomy_term__parent.parent_target_id; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.taxonomy_term__parent.parent_target_id IS 'The ID of the target entity.';


--
-- Name: taxonomy_term_data; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.taxonomy_term_data (
    tid integer NOT NULL,
    revision_id bigint,
    vid character varying(32) NOT NULL,
    uuid character varying(128) NOT NULL,
    langcode character varying(12) NOT NULL,
    CONSTRAINT taxonomy_term_data_revision_id_check CHECK ((revision_id >= 0)),
    CONSTRAINT taxonomy_term_data_tid_check CHECK ((tid >= 0))
);


ALTER TABLE public.taxonomy_term_data OWNER TO root;

--
-- Name: TABLE taxonomy_term_data; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.taxonomy_term_data IS 'The base table for taxonomy_term entities.';


--
-- Name: COLUMN taxonomy_term_data.vid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.taxonomy_term_data.vid IS 'The ID of the target entity.';


--
-- Name: taxonomy_term_data_tid_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.taxonomy_term_data_tid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.taxonomy_term_data_tid_seq OWNER TO root;

--
-- Name: taxonomy_term_data_tid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.taxonomy_term_data_tid_seq OWNED BY public.taxonomy_term_data.tid;


--
-- Name: taxonomy_term_field_data; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.taxonomy_term_field_data (
    tid bigint NOT NULL,
    revision_id bigint NOT NULL,
    vid character varying(32) NOT NULL,
    langcode character varying(12) NOT NULL,
    status smallint NOT NULL,
    name character varying(255) NOT NULL,
    description__value text,
    description__format character varying(255),
    weight integer NOT NULL,
    changed integer,
    default_langcode smallint NOT NULL,
    revision_translation_affected smallint,
    CONSTRAINT taxonomy_term_field_data_revision_id_check CHECK ((revision_id >= 0)),
    CONSTRAINT taxonomy_term_field_data_tid_check CHECK ((tid >= 0))
);


ALTER TABLE public.taxonomy_term_field_data OWNER TO root;

--
-- Name: TABLE taxonomy_term_field_data; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.taxonomy_term_field_data IS 'The data table for taxonomy_term entities.';


--
-- Name: COLUMN taxonomy_term_field_data.vid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.taxonomy_term_field_data.vid IS 'The ID of the target entity.';


--
-- Name: taxonomy_term_field_revision; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.taxonomy_term_field_revision (
    tid bigint NOT NULL,
    revision_id bigint NOT NULL,
    langcode character varying(12) NOT NULL,
    status smallint NOT NULL,
    name character varying(255),
    description__value text,
    description__format character varying(255),
    changed integer,
    default_langcode smallint NOT NULL,
    revision_translation_affected smallint,
    CONSTRAINT taxonomy_term_field_revision_revision_id_check CHECK ((revision_id >= 0)),
    CONSTRAINT taxonomy_term_field_revision_tid_check CHECK ((tid >= 0))
);


ALTER TABLE public.taxonomy_term_field_revision OWNER TO root;

--
-- Name: TABLE taxonomy_term_field_revision; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.taxonomy_term_field_revision IS 'The revision data table for taxonomy_term entities.';


--
-- Name: taxonomy_term_revision; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.taxonomy_term_revision (
    tid bigint NOT NULL,
    revision_id integer NOT NULL,
    langcode character varying(12) NOT NULL,
    revision_user bigint,
    revision_created integer,
    revision_log_message text,
    revision_default smallint,
    CONSTRAINT taxonomy_term_revision_revision_id_check CHECK ((revision_id >= 0)),
    CONSTRAINT taxonomy_term_revision_revision_user_check CHECK ((revision_user >= 0)),
    CONSTRAINT taxonomy_term_revision_tid_check CHECK ((tid >= 0))
);


ALTER TABLE public.taxonomy_term_revision OWNER TO root;

--
-- Name: TABLE taxonomy_term_revision; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.taxonomy_term_revision IS 'The revision table for taxonomy_term entities.';


--
-- Name: COLUMN taxonomy_term_revision.revision_user; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.taxonomy_term_revision.revision_user IS 'The ID of the target entity.';


--
-- Name: taxonomy_term_revision__parent; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.taxonomy_term_revision__parent (
    bundle character varying(128) DEFAULT ''::character varying NOT NULL,
    deleted smallint DEFAULT 0 NOT NULL,
    entity_id bigint NOT NULL,
    revision_id bigint NOT NULL,
    langcode character varying(32) DEFAULT ''::character varying NOT NULL,
    delta bigint NOT NULL,
    parent_target_id bigint NOT NULL,
    CONSTRAINT taxonomy_term_revision__parent_delta_check CHECK ((delta >= 0)),
    CONSTRAINT taxonomy_term_revision__parent_entity_id_check CHECK ((entity_id >= 0)),
    CONSTRAINT taxonomy_term_revision__parent_parent_target_id_check CHECK ((parent_target_id >= 0)),
    CONSTRAINT taxonomy_term_revision__parent_revision_id_check CHECK ((revision_id >= 0))
);


ALTER TABLE public.taxonomy_term_revision__parent OWNER TO root;

--
-- Name: TABLE taxonomy_term_revision__parent; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.taxonomy_term_revision__parent IS 'Revision archive storage for taxonomy_term field parent.';


--
-- Name: COLUMN taxonomy_term_revision__parent.bundle; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.taxonomy_term_revision__parent.bundle IS 'The field instance bundle to which this row belongs, used when deleting a field instance';


--
-- Name: COLUMN taxonomy_term_revision__parent.deleted; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.taxonomy_term_revision__parent.deleted IS 'A boolean indicating whether this data item has been deleted';


--
-- Name: COLUMN taxonomy_term_revision__parent.entity_id; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.taxonomy_term_revision__parent.entity_id IS 'The entity id this data is attached to';


--
-- Name: COLUMN taxonomy_term_revision__parent.revision_id; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.taxonomy_term_revision__parent.revision_id IS 'The entity revision id this data is attached to';


--
-- Name: COLUMN taxonomy_term_revision__parent.langcode; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.taxonomy_term_revision__parent.langcode IS 'The language code for this data item.';


--
-- Name: COLUMN taxonomy_term_revision__parent.delta; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.taxonomy_term_revision__parent.delta IS 'The sequence number for this data item, used for multi-value fields';


--
-- Name: COLUMN taxonomy_term_revision__parent.parent_target_id; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.taxonomy_term_revision__parent.parent_target_id IS 'The ID of the target entity.';


--
-- Name: taxonomy_term_revision_revision_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.taxonomy_term_revision_revision_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.taxonomy_term_revision_revision_id_seq OWNER TO root;

--
-- Name: taxonomy_term_revision_revision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.taxonomy_term_revision_revision_id_seq OWNED BY public.taxonomy_term_revision.revision_id;


--
-- Name: user__roles; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.user__roles (
    bundle character varying(128) DEFAULT ''::character varying NOT NULL,
    deleted smallint DEFAULT 0 NOT NULL,
    entity_id bigint NOT NULL,
    revision_id bigint NOT NULL,
    langcode character varying(32) DEFAULT ''::character varying NOT NULL,
    delta bigint NOT NULL,
    roles_target_id character varying(255) NOT NULL,
    CONSTRAINT user__roles_delta_check CHECK ((delta >= 0)),
    CONSTRAINT user__roles_entity_id_check CHECK ((entity_id >= 0)),
    CONSTRAINT user__roles_revision_id_check CHECK ((revision_id >= 0))
);


ALTER TABLE public.user__roles OWNER TO root;

--
-- Name: TABLE user__roles; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.user__roles IS 'Data storage for user field roles.';


--
-- Name: COLUMN user__roles.bundle; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.user__roles.bundle IS 'The field instance bundle to which this row belongs, used when deleting a field instance';


--
-- Name: COLUMN user__roles.deleted; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.user__roles.deleted IS 'A boolean indicating whether this data item has been deleted';


--
-- Name: COLUMN user__roles.entity_id; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.user__roles.entity_id IS 'The entity id this data is attached to';


--
-- Name: COLUMN user__roles.revision_id; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.user__roles.revision_id IS 'The entity revision id this data is attached to, which for an unversioned entity type is the same as the entity id';


--
-- Name: COLUMN user__roles.langcode; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.user__roles.langcode IS 'The language code for this data item.';


--
-- Name: COLUMN user__roles.delta; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.user__roles.delta IS 'The sequence number for this data item, used for multi-value fields';


--
-- Name: COLUMN user__roles.roles_target_id; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.user__roles.roles_target_id IS 'The ID of the target entity.';


--
-- Name: user__user_picture; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.user__user_picture (
    bundle character varying(128) DEFAULT ''::character varying NOT NULL,
    deleted smallint DEFAULT 0 NOT NULL,
    entity_id bigint NOT NULL,
    revision_id bigint NOT NULL,
    langcode character varying(32) DEFAULT ''::character varying NOT NULL,
    delta bigint NOT NULL,
    user_picture_target_id bigint NOT NULL,
    user_picture_alt character varying(512),
    user_picture_title character varying(1024),
    user_picture_width bigint,
    user_picture_height bigint,
    CONSTRAINT user__user_picture_delta_check CHECK ((delta >= 0)),
    CONSTRAINT user__user_picture_entity_id_check CHECK ((entity_id >= 0)),
    CONSTRAINT user__user_picture_revision_id_check CHECK ((revision_id >= 0)),
    CONSTRAINT user__user_picture_user_picture_height_check CHECK ((user_picture_height >= 0)),
    CONSTRAINT user__user_picture_user_picture_target_id_check CHECK ((user_picture_target_id >= 0)),
    CONSTRAINT user__user_picture_user_picture_width_check CHECK ((user_picture_width >= 0))
);


ALTER TABLE public.user__user_picture OWNER TO root;

--
-- Name: TABLE user__user_picture; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.user__user_picture IS 'Data storage for user field user_picture.';


--
-- Name: COLUMN user__user_picture.bundle; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.user__user_picture.bundle IS 'The field instance bundle to which this row belongs, used when deleting a field instance';


--
-- Name: COLUMN user__user_picture.deleted; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.user__user_picture.deleted IS 'A boolean indicating whether this data item has been deleted';


--
-- Name: COLUMN user__user_picture.entity_id; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.user__user_picture.entity_id IS 'The entity id this data is attached to';


--
-- Name: COLUMN user__user_picture.revision_id; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.user__user_picture.revision_id IS 'The entity revision id this data is attached to, which for an unversioned entity type is the same as the entity id';


--
-- Name: COLUMN user__user_picture.langcode; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.user__user_picture.langcode IS 'The language code for this data item.';


--
-- Name: COLUMN user__user_picture.delta; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.user__user_picture.delta IS 'The sequence number for this data item, used for multi-value fields';


--
-- Name: COLUMN user__user_picture.user_picture_target_id; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.user__user_picture.user_picture_target_id IS 'The ID of the file entity.';


--
-- Name: COLUMN user__user_picture.user_picture_alt; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.user__user_picture.user_picture_alt IS 'Alternative image text, for the image''s ''alt'' attribute.';


--
-- Name: COLUMN user__user_picture.user_picture_title; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.user__user_picture.user_picture_title IS 'Image title text, for the image''s ''title'' attribute.';


--
-- Name: COLUMN user__user_picture.user_picture_width; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.user__user_picture.user_picture_width IS 'The width of the image in pixels.';


--
-- Name: COLUMN user__user_picture.user_picture_height; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.user__user_picture.user_picture_height IS 'The height of the image in pixels.';


--
-- Name: users; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.users (
    uid integer NOT NULL,
    uuid character varying(128) NOT NULL,
    langcode character varying(12) NOT NULL,
    CONSTRAINT users_uid_check CHECK ((uid >= 0))
);


ALTER TABLE public.users OWNER TO root;

--
-- Name: TABLE users; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.users IS 'The base table for user entities.';


--
-- Name: users_data; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.users_data (
    uid bigint DEFAULT 0 NOT NULL,
    module character varying(50) DEFAULT ''::character varying NOT NULL,
    name character varying(128) DEFAULT ''::character varying NOT NULL,
    value bytea,
    serialized integer DEFAULT 0,
    CONSTRAINT users_data_serialized_check CHECK ((serialized >= 0)),
    CONSTRAINT users_data_uid_check CHECK ((uid >= 0))
);


ALTER TABLE public.users_data OWNER TO root;

--
-- Name: TABLE users_data; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.users_data IS 'Stores module data as key/value pairs per user.';


--
-- Name: COLUMN users_data.uid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.users_data.uid IS 'The "users".uid this record affects.';


--
-- Name: COLUMN users_data.module; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.users_data.module IS 'The name of the module declaring the variable.';


--
-- Name: COLUMN users_data.name; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.users_data.name IS 'The identifier of the data.';


--
-- Name: COLUMN users_data.value; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.users_data.value IS 'The value.';


--
-- Name: COLUMN users_data.serialized; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.users_data.serialized IS 'Whether value is serialized.';


--
-- Name: users_field_data; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.users_field_data (
    uid bigint NOT NULL,
    langcode character varying(12) NOT NULL,
    preferred_langcode character varying(12),
    preferred_admin_langcode character varying(12),
    name character varying(60) NOT NULL,
    pass character varying(255),
    mail character varying(254),
    timezone character varying(32),
    status smallint,
    created integer NOT NULL,
    changed integer,
    access integer NOT NULL,
    login integer,
    init character varying(254),
    default_langcode smallint NOT NULL,
    CONSTRAINT users_field_data_uid_check CHECK ((uid >= 0))
);


ALTER TABLE public.users_field_data OWNER TO root;

--
-- Name: TABLE users_field_data; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.users_field_data IS 'The data table for user entities.';


--
-- Name: users_uid_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.users_uid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_uid_seq OWNER TO root;

--
-- Name: users_uid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.users_uid_seq OWNED BY public.users.uid;


--
-- Name: watchdog; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.watchdog (
    wid bigint NOT NULL,
    uid bigint DEFAULT 0 NOT NULL,
    type character varying(64) DEFAULT ''::character varying NOT NULL,
    message text NOT NULL,
    variables bytea NOT NULL,
    severity integer DEFAULT 0 NOT NULL,
    link text,
    location text NOT NULL,
    referer text,
    hostname character varying(128) DEFAULT ''::character varying NOT NULL,
    "timestamp" bigint DEFAULT 0 NOT NULL,
    CONSTRAINT watchdog_severity_check CHECK ((severity >= 0)),
    CONSTRAINT watchdog_uid_check CHECK ((uid >= 0))
);


ALTER TABLE public.watchdog OWNER TO root;

--
-- Name: TABLE watchdog; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.watchdog IS 'Table that contains logs of all system events.';


--
-- Name: COLUMN watchdog.wid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.watchdog.wid IS 'Primary Key: Unique watchdog event ID.';


--
-- Name: COLUMN watchdog.uid; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.watchdog.uid IS 'The "users".uid of the user who triggered the event.';


--
-- Name: COLUMN watchdog.type; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.watchdog.type IS 'Type of log message, for example "user" or "page not found."';


--
-- Name: COLUMN watchdog.message; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.watchdog.message IS 'Text of log message to be passed into the t() function.';


--
-- Name: COLUMN watchdog.variables; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.watchdog.variables IS 'Serialized array of variables that match the message string and that is passed into the t() function.';


--
-- Name: COLUMN watchdog.severity; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.watchdog.severity IS 'The severity level of the event. ranges from 0 (Emergency) to 7 (Debug)';


--
-- Name: COLUMN watchdog.link; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.watchdog.link IS 'Link to view the result of the event.';


--
-- Name: COLUMN watchdog.location; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.watchdog.location IS 'URL of the origin of the event.';


--
-- Name: COLUMN watchdog.referer; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.watchdog.referer IS 'URL of referring page.';


--
-- Name: COLUMN watchdog.hostname; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.watchdog.hostname IS 'Hostname of the user who triggered the event.';


--
-- Name: COLUMN watchdog."timestamp"; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.watchdog."timestamp" IS 'Unix timestamp of when event occurred.';


--
-- Name: watchdog_wid_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.watchdog_wid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.watchdog_wid_seq OWNER TO root;

--
-- Name: watchdog_wid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.watchdog_wid_seq OWNED BY public.watchdog.wid;
