-- The Personal Development demo's backend, on the demo Supabase project.
-- Run it once in the SQL editor as postgres, on a project where the shared demo
-- account demo@symplr.io already exists (Food Couriers' demo-reset.sql creates it
-- and keeps its password).
--
-- 1. The app's schema: 13 tables, each with row-level security, so the public
--    anon key reads only rows marked is_sample and a signed-in user reads only
--    their own rows.
-- 2. Seed rows, kept in demo_admin.
-- 3. demo_admin.reset_personal_development(), which puts every table back to the
--    seed every 30 minutes, with the demo account's journal, check-ins and profile.
--
-- Afterwards, add the schema to PostgREST's exposed schemas (Settings > API).

create extension if not exists pg_cron with schema pg_catalog;

create schema if not exists symplr_c41f7c7a_de20_4401_a958_0892c920bfc7;
grant usage on schema symplr_c41f7c7a_de20_4401_a958_0892c920bfc7 to anon, authenticated, service_role;
create table symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.badges (
  "id" uuid default gen_random_uuid() not null,
  "name" character varying(255),
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "auth_user_id" uuid not null,
  "is_sample" boolean default false not null,
  constraint "badges_pkey" PRIMARY KEY (id)
);
alter table symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.badges enable row level security;
create policy "owner_delete" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.badges as permissive for delete to authenticated using ((auth.uid() = auth_user_id));
create policy "owner_insert" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.badges as permissive for insert to authenticated with check ((auth.uid() = auth_user_id));
create policy "owner_select" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.badges as permissive for select to authenticated using ((auth.uid() = auth_user_id));
create policy "owner_update" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.badges as permissive for update to authenticated using ((auth.uid() = auth_user_id)) with check ((auth.uid() = auth_user_id));
create policy "sample_select" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.badges as permissive for select to anon,authenticated using (is_sample);
grant select, insert, update, delete on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.badges to anon, authenticated, service_role;
create table symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.check_ins (
  "id" uuid default gen_random_uuid() not null,
  "overall_mood" character varying(255),
  "mind" jsonb,
  "energy_level" numeric,
  "feel_now" character varying(255),
  "stress_level" numeric,
  "kind" character varying(255),
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "auth_user_id" uuid not null,
  "is_sample" boolean default false not null,
  "journey" character varying(255),
  "day" numeric,
  "day_name" character varying(255),
  constraint "check_ins_pkey" PRIMARY KEY (id)
);
alter table symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.check_ins enable row level security;
create policy "owner_delete" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.check_ins as permissive for delete to authenticated using ((auth.uid() = auth_user_id));
create policy "owner_insert" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.check_ins as permissive for insert to authenticated with check ((auth.uid() = auth_user_id));
create policy "owner_select" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.check_ins as permissive for select to authenticated using ((auth.uid() = auth_user_id));
create policy "owner_update" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.check_ins as permissive for update to authenticated using ((auth.uid() = auth_user_id)) with check ((auth.uid() = auth_user_id));
create policy "sample_select" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.check_ins as permissive for select to anon,authenticated using (is_sample);
grant select, insert, update, delete on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.check_ins to anon, authenticated, service_role;
create table symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.contents (
  "id" uuid default gen_random_uuid() not null,
  "image_url" character varying(255),
  "name" character varying(255),
  "subtitle" character varying(255),
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "auth_user_id" uuid not null,
  "is_sample" boolean default false not null,
  constraint "contents_pkey" PRIMARY KEY (id)
);
alter table symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.contents enable row level security;
create policy "owner_delete" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.contents as permissive for delete to authenticated using ((auth.uid() = auth_user_id));
create policy "owner_insert" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.contents as permissive for insert to authenticated with check ((auth.uid() = auth_user_id));
create policy "owner_select" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.contents as permissive for select to authenticated using ((auth.uid() = auth_user_id));
create policy "owner_update" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.contents as permissive for update to authenticated using ((auth.uid() = auth_user_id)) with check ((auth.uid() = auth_user_id));
create policy "sample_select" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.contents as permissive for select to anon,authenticated using (is_sample);
grant select, insert, update, delete on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.contents to anon, authenticated, service_role;
create table symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.goals (
  "id" uuid default gen_random_uuid() not null,
  "name" character varying(255),
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "auth_user_id" uuid not null,
  "is_sample" boolean default false not null,
  constraint "goals_pkey" PRIMARY KEY (id)
);
alter table symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.goals enable row level security;
create policy "owner_delete" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.goals as permissive for delete to authenticated using ((auth.uid() = auth_user_id));
create policy "owner_insert" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.goals as permissive for insert to authenticated with check ((auth.uid() = auth_user_id));
create policy "owner_select" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.goals as permissive for select to authenticated using ((auth.uid() = auth_user_id));
create policy "owner_update" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.goals as permissive for update to authenticated using ((auth.uid() = auth_user_id)) with check ((auth.uid() = auth_user_id));
create policy "sample_select" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.goals as permissive for select to anon,authenticated using (is_sample);
grant select, insert, update, delete on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.goals to anon, authenticated, service_role;
create table symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.journal_entries (
  "id" uuid default gen_random_uuid() not null,
  "body" text,
  "prompt" text,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "auth_user_id" uuid not null,
  "is_sample" boolean default false not null,
  "journey" character varying(255),
  "day" numeric,
  "day_name" character varying(255),
  "entry_date" character varying(255),
  constraint "journal_entries_pkey" PRIMARY KEY (id)
);
alter table symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.journal_entries enable row level security;
create policy "owner_delete" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.journal_entries as permissive for delete to authenticated using ((auth.uid() = auth_user_id));
create policy "owner_insert" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.journal_entries as permissive for insert to authenticated with check ((auth.uid() = auth_user_id));
create policy "owner_select" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.journal_entries as permissive for select to authenticated using ((auth.uid() = auth_user_id));
create policy "owner_update" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.journal_entries as permissive for update to authenticated using ((auth.uid() = auth_user_id)) with check ((auth.uid() = auth_user_id));
create policy "sample_select" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.journal_entries as permissive for select to anon,authenticated using (is_sample);
grant select, insert, update, delete on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.journal_entries to anon, authenticated, service_role;
create table symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.journeies (
  "id" uuid default gen_random_uuid() not null,
  "name" character varying(255),
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "auth_user_id" uuid not null,
  "is_sample" boolean default false not null,
  constraint "journeies_pkey" PRIMARY KEY (id)
);
alter table symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.journeies enable row level security;
create policy "owner_delete" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.journeies as permissive for delete to authenticated using ((auth.uid() = auth_user_id));
create policy "owner_insert" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.journeies as permissive for insert to authenticated with check ((auth.uid() = auth_user_id));
create policy "owner_select" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.journeies as permissive for select to authenticated using ((auth.uid() = auth_user_id));
create policy "owner_update" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.journeies as permissive for update to authenticated using ((auth.uid() = auth_user_id)) with check ((auth.uid() = auth_user_id));
create policy "sample_select" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.journeies as permissive for select to anon,authenticated using (is_sample);
grant select, insert, update, delete on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.journeies to anon, authenticated, service_role;
create table symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.libraries (
  "id" uuid default gen_random_uuid() not null,
  "image_url" character varying(255),
  "name" character varying(255),
  "subtitle" character varying(255),
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "auth_user_id" uuid not null,
  "is_sample" boolean default false not null,
  constraint "libraries_pkey" PRIMARY KEY (id)
);
alter table symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.libraries enable row level security;
create policy "owner_delete" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.libraries as permissive for delete to authenticated using ((auth.uid() = auth_user_id));
create policy "owner_insert" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.libraries as permissive for insert to authenticated with check ((auth.uid() = auth_user_id));
create policy "owner_select" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.libraries as permissive for select to authenticated using ((auth.uid() = auth_user_id));
create policy "owner_update" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.libraries as permissive for update to authenticated using ((auth.uid() = auth_user_id)) with check ((auth.uid() = auth_user_id));
create policy "sample_select" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.libraries as permissive for select to anon,authenticated using (is_sample);
grant select, insert, update, delete on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.libraries to anon, authenticated, service_role;
create table symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.milestones (
  "id" uuid default gen_random_uuid() not null,
  "stress_level" numeric,
  "sleep_quality" numeric,
  "self_compassion" numeric,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "auth_user_id" uuid not null,
  "is_sample" boolean default false not null,
  "journey" character varying(255),
  "day" numeric,
  "day_name" character varying(255),
  constraint "milestones_pkey" PRIMARY KEY (id)
);
alter table symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.milestones enable row level security;
create policy "owner_delete" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.milestones as permissive for delete to authenticated using ((auth.uid() = auth_user_id));
create policy "owner_insert" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.milestones as permissive for insert to authenticated with check ((auth.uid() = auth_user_id));
create policy "owner_select" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.milestones as permissive for select to authenticated using ((auth.uid() = auth_user_id));
create policy "owner_update" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.milestones as permissive for update to authenticated using ((auth.uid() = auth_user_id)) with check ((auth.uid() = auth_user_id));
create policy "sample_select" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.milestones as permissive for select to anon,authenticated using (is_sample);
grant select, insert, update, delete on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.milestones to anon, authenticated, service_role;
create table symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.plans (
  "id" uuid default gen_random_uuid() not null,
  "milestones" boolean default true,
  "downloads" boolean default true,
  "insights" boolean default true,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "auth_user_id" uuid not null,
  "is_sample" boolean default false not null,
  constraint "plans_pkey" PRIMARY KEY (id)
);
alter table symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.plans enable row level security;
create policy "owner_delete" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.plans as permissive for delete to authenticated using ((auth.uid() = auth_user_id));
create policy "owner_insert" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.plans as permissive for insert to authenticated with check ((auth.uid() = auth_user_id));
create policy "owner_select" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.plans as permissive for select to authenticated using ((auth.uid() = auth_user_id));
create policy "owner_update" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.plans as permissive for update to authenticated using ((auth.uid() = auth_user_id)) with check ((auth.uid() = auth_user_id));
create policy "sample_select" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.plans as permissive for select to anon,authenticated using (is_sample);
grant select, insert, update, delete on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.plans to anon, authenticated, service_role;
create table symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.profiles (
  "id" uuid default gen_random_uuid() not null,
  "display_name" character varying(255),
  "email" character varying(255),
  "avatar_url" character varying(255),
  "notifications_enabled" boolean,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "auth_user_id" uuid not null,
  "is_sample" boolean default false not null,
  constraint "profiles_auth_user_id_key" UNIQUE (auth_user_id),
  constraint "profiles_pkey" PRIMARY KEY (id)
);
alter table symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.profiles enable row level security;
create policy "owner_delete" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.profiles as permissive for delete to authenticated using ((auth.uid() = auth_user_id));
create policy "owner_insert" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.profiles as permissive for insert to authenticated with check ((auth.uid() = auth_user_id));
create policy "owner_select" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.profiles as permissive for select to authenticated using ((auth.uid() = auth_user_id));
create policy "owner_update" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.profiles as permissive for update to authenticated using ((auth.uid() = auth_user_id)) with check ((auth.uid() = auth_user_id));
create policy "sample_select" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.profiles as permissive for select to anon,authenticated using (is_sample);
grant select, insert, update, delete on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.profiles to anon, authenticated, service_role;
create table symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.settings (
  "id" uuid default gen_random_uuid() not null,
  "image_url" character varying(255),
  "name" character varying(255),
  "photo_url" character varying(255),
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "auth_user_id" uuid not null,
  "is_sample" boolean default false not null,
  constraint "settings_pkey" PRIMARY KEY (id)
);
alter table symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.settings enable row level security;
create policy "owner_delete" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.settings as permissive for delete to authenticated using ((auth.uid() = auth_user_id));
create policy "owner_insert" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.settings as permissive for insert to authenticated with check ((auth.uid() = auth_user_id));
create policy "owner_select" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.settings as permissive for select to authenticated using ((auth.uid() = auth_user_id));
create policy "owner_update" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.settings as permissive for update to authenticated using ((auth.uid() = auth_user_id)) with check ((auth.uid() = auth_user_id));
create policy "sample_select" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.settings as permissive for select to anon,authenticated using (is_sample);
grant select, insert, update, delete on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.settings to anon, authenticated, service_role;
create table symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.subscriptions (
  "id" uuid default gen_random_uuid() not null,
  "unlocked" boolean default true,
  "library" boolean default true,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "auth_user_id" uuid not null,
  "is_sample" boolean default false not null,
  constraint "subscriptions_pkey" PRIMARY KEY (id)
);
alter table symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.subscriptions enable row level security;
create policy "owner_delete" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.subscriptions as permissive for delete to authenticated using ((auth.uid() = auth_user_id));
create policy "owner_insert" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.subscriptions as permissive for insert to authenticated with check ((auth.uid() = auth_user_id));
create policy "owner_select" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.subscriptions as permissive for select to authenticated using ((auth.uid() = auth_user_id));
create policy "owner_update" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.subscriptions as permissive for update to authenticated using ((auth.uid() = auth_user_id)) with check ((auth.uid() = auth_user_id));
create policy "sample_select" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.subscriptions as permissive for select to anon,authenticated using (is_sample);
grant select, insert, update, delete on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.subscriptions to anon, authenticated, service_role;
create table symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.week1s (
  "id" uuid default gen_random_uuid() not null,
  "name" character varying(255),
  "subtitle" character varying(255),
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "auth_user_id" uuid not null,
  "is_sample" boolean default false not null,
  constraint "week1s_pkey" PRIMARY KEY (id)
);
alter table symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.week1s enable row level security;
create policy "owner_delete" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.week1s as permissive for delete to authenticated using ((auth.uid() = auth_user_id));
create policy "owner_insert" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.week1s as permissive for insert to authenticated with check ((auth.uid() = auth_user_id));
create policy "owner_select" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.week1s as permissive for select to authenticated using ((auth.uid() = auth_user_id));
create policy "owner_update" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.week1s as permissive for update to authenticated using ((auth.uid() = auth_user_id)) with check ((auth.uid() = auth_user_id));
create policy "sample_select" on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.week1s as permissive for select to anon,authenticated using (is_sample);
grant select, insert, update, delete on symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.week1s to anon, authenticated, service_role;
CREATE OR REPLACE FUNCTION symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.symplr_c41f7c7a_de20_4401_a958_0892c920bfc7_badges_set_auth_use()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
       BEGIN
         IF NEW.auth_user_id IS NULL THEN
           NEW.auth_user_id := auth.uid();
         END IF;
         RETURN NEW;
       END;
       $function$;
CREATE OR REPLACE FUNCTION symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.symplr_c41f7c7a_de20_4401_a958_0892c920bfc7_check_ins_set_auth_()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
       BEGIN
         IF NEW.auth_user_id IS NULL THEN
           NEW.auth_user_id := auth.uid();
         END IF;
         RETURN NEW;
       END;
       $function$;
CREATE OR REPLACE FUNCTION symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.symplr_c41f7c7a_de20_4401_a958_0892c920bfc7_contents_set_auth_u()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
       BEGIN
         IF NEW.auth_user_id IS NULL THEN
           NEW.auth_user_id := auth.uid();
         END IF;
         RETURN NEW;
       END;
       $function$;
CREATE OR REPLACE FUNCTION symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.symplr_c41f7c7a_de20_4401_a958_0892c920bfc7_goals_set_auth_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
       BEGIN
         IF NEW.auth_user_id IS NULL THEN
           NEW.auth_user_id := auth.uid();
         END IF;
         RETURN NEW;
       END;
       $function$;
CREATE OR REPLACE FUNCTION symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.symplr_c41f7c7a_de20_4401_a958_0892c920bfc7_journal_entries_set()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
       BEGIN
         IF NEW.auth_user_id IS NULL THEN
           NEW.auth_user_id := auth.uid();
         END IF;
         RETURN NEW;
       END;
       $function$;
CREATE OR REPLACE FUNCTION symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.symplr_c41f7c7a_de20_4401_a958_0892c920bfc7_journeies_set_auth_()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
       BEGIN
         IF NEW.auth_user_id IS NULL THEN
           NEW.auth_user_id := auth.uid();
         END IF;
         RETURN NEW;
       END;
       $function$;
CREATE OR REPLACE FUNCTION symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.symplr_c41f7c7a_de20_4401_a958_0892c920bfc7_libraries_set_auth_()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
       BEGIN
         IF NEW.auth_user_id IS NULL THEN
           NEW.auth_user_id := auth.uid();
         END IF;
         RETURN NEW;
       END;
       $function$;
CREATE OR REPLACE FUNCTION symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.symplr_c41f7c7a_de20_4401_a958_0892c920bfc7_milestones_set_auth()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
       BEGIN
         IF NEW.auth_user_id IS NULL THEN
           NEW.auth_user_id := auth.uid();
         END IF;
         RETURN NEW;
       END;
       $function$;
CREATE OR REPLACE FUNCTION symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.symplr_c41f7c7a_de20_4401_a958_0892c920bfc7_plans_set_auth_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
       BEGIN
         IF NEW.auth_user_id IS NULL THEN
           NEW.auth_user_id := auth.uid();
         END IF;
         RETURN NEW;
       END;
       $function$;
CREATE OR REPLACE FUNCTION symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.symplr_c41f7c7a_de20_4401_a958_0892c920bfc7_profiles_set_auth_u()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
       BEGIN
         IF NEW.auth_user_id IS NULL THEN
           NEW.auth_user_id := auth.uid();
         END IF;
         RETURN NEW;
       END;
       $function$;
CREATE OR REPLACE FUNCTION symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.symplr_c41f7c7a_de20_4401_a958_0892c920bfc7_settings_set_auth_u()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
       BEGIN
         IF NEW.auth_user_id IS NULL THEN
           NEW.auth_user_id := auth.uid();
         END IF;
         RETURN NEW;
       END;
       $function$;
CREATE OR REPLACE FUNCTION symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.symplr_c41f7c7a_de20_4401_a958_0892c920bfc7_subscriptions_set_a()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
       BEGIN
         IF NEW.auth_user_id IS NULL THEN
           NEW.auth_user_id := auth.uid();
         END IF;
         RETURN NEW;
       END;
       $function$;
CREATE OR REPLACE FUNCTION symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.symplr_c41f7c7a_de20_4401_a958_0892c920bfc7_week1s_set_auth_use()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
       BEGIN
         IF NEW.auth_user_id IS NULL THEN
           NEW.auth_user_id := auth.uid();
         END IF;
         RETURN NEW;
       END;
       $function$;
CREATE TRIGGER trg_set_auth_user_id BEFORE INSERT ON symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.badges FOR EACH ROW EXECUTE FUNCTION symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.symplr_c41f7c7a_de20_4401_a958_0892c920bfc7_badges_set_auth_use();
CREATE TRIGGER trg_set_auth_user_id BEFORE INSERT ON symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.check_ins FOR EACH ROW EXECUTE FUNCTION symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.symplr_c41f7c7a_de20_4401_a958_0892c920bfc7_check_ins_set_auth_();
CREATE TRIGGER trg_set_auth_user_id BEFORE INSERT ON symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.contents FOR EACH ROW EXECUTE FUNCTION symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.symplr_c41f7c7a_de20_4401_a958_0892c920bfc7_contents_set_auth_u();
CREATE TRIGGER trg_set_auth_user_id BEFORE INSERT ON symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.goals FOR EACH ROW EXECUTE FUNCTION symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.symplr_c41f7c7a_de20_4401_a958_0892c920bfc7_goals_set_auth_user();
CREATE TRIGGER trg_set_auth_user_id BEFORE INSERT ON symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.journal_entries FOR EACH ROW EXECUTE FUNCTION symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.symplr_c41f7c7a_de20_4401_a958_0892c920bfc7_journal_entries_set();
CREATE TRIGGER trg_set_auth_user_id BEFORE INSERT ON symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.journeies FOR EACH ROW EXECUTE FUNCTION symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.symplr_c41f7c7a_de20_4401_a958_0892c920bfc7_journeies_set_auth_();
CREATE TRIGGER trg_set_auth_user_id BEFORE INSERT ON symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.libraries FOR EACH ROW EXECUTE FUNCTION symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.symplr_c41f7c7a_de20_4401_a958_0892c920bfc7_libraries_set_auth_();
CREATE TRIGGER trg_set_auth_user_id BEFORE INSERT ON symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.milestones FOR EACH ROW EXECUTE FUNCTION symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.symplr_c41f7c7a_de20_4401_a958_0892c920bfc7_milestones_set_auth();
CREATE TRIGGER trg_set_auth_user_id BEFORE INSERT ON symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.plans FOR EACH ROW EXECUTE FUNCTION symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.symplr_c41f7c7a_de20_4401_a958_0892c920bfc7_plans_set_auth_user();
CREATE TRIGGER trg_set_auth_user_id BEFORE INSERT ON symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.profiles FOR EACH ROW EXECUTE FUNCTION symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.symplr_c41f7c7a_de20_4401_a958_0892c920bfc7_profiles_set_auth_u();
CREATE TRIGGER trg_set_auth_user_id BEFORE INSERT ON symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.settings FOR EACH ROW EXECUTE FUNCTION symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.symplr_c41f7c7a_de20_4401_a958_0892c920bfc7_settings_set_auth_u();
CREATE TRIGGER trg_set_auth_user_id BEFORE INSERT ON symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.subscriptions FOR EACH ROW EXECUTE FUNCTION symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.symplr_c41f7c7a_de20_4401_a958_0892c920bfc7_subscriptions_set_a();
CREATE TRIGGER trg_set_auth_user_id BEFORE INSERT ON symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.week1s FOR EACH ROW EXECUTE FUNCTION symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.symplr_c41f7c7a_de20_4401_a958_0892c920bfc7_week1s_set_auth_use();
CREATE UNIQUE INDEX profiles_owner_uniq ON symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.profiles USING btree (auth_user_id);

create schema if not exists demo_admin;
revoke all on schema demo_admin from anon, authenticated, public;
create table demo_admin.pd_seed_week1s as select * from symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.week1s with no data;
insert into demo_admin.pd_seed_week1s ("id", "name", "subtitle", "created_at", "updated_at", "auth_user_id", "is_sample") values ('3b682880-39bd-439e-90ac-5deb3c05a794', 'Stress level', '4 / 10', '2026-11-25T04:41:19.034323+00:00', '2026-11-25T05:40:35.264858+00:00', 'dc9b81c8-0d95-4fec-9aeb-7bdb5a3f36dc', true);
insert into demo_admin.pd_seed_week1s ("id", "name", "subtitle", "created_at", "updated_at", "auth_user_id", "is_sample") values ('84752ce0-4255-4f82-86ad-c6b8e2223cd1', 'Sleep quality', '7 / 10', '2026-11-25T04:41:20.034323+00:00', '2026-11-25T05:40:35.264858+00:00', 'dc9b81c8-0d95-4fec-9aeb-7bdb5a3f36dc', true);
insert into demo_admin.pd_seed_week1s ("id", "name", "subtitle", "created_at", "updated_at", "auth_user_id", "is_sample") values ('c9a44709-f801-47b0-864f-591e69c494c0', 'Self-compassion', '6 / 10', '2026-11-25T04:41:21.034323+00:00', '2026-11-25T05:40:35.264858+00:00', 'dc9b81c8-0d95-4fec-9aeb-7bdb5a3f36dc', true);
create table demo_admin.pd_seed_libraries as select * from symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.libraries with no data;
insert into demo_admin.pd_seed_libraries ("id", "image_url", "name", "subtitle", "created_at", "updated_at", "auth_user_id", "is_sample") values ('a06f5005-6336-40ed-aa9d-450eabfb99ab', 'https://wjvpjyvyavyapvrrmvjq.supabase.co/storage/v1/object/public/demo-assets/personal-development/a25c1f42e16d6cc261f2a4d8b94440a9ece1bc4d2f39ec7b4652c5a78e75cf06.webp', 'Morning Reset', null, '2026-11-25T04:41:19.034323+00:00', '2026-11-25T05:40:35.264858+00:00', 'dc9b81c8-0d95-4fec-9aeb-7bdb5a3f36dc', true);
insert into demo_admin.pd_seed_libraries ("id", "image_url", "name", "subtitle", "created_at", "updated_at", "auth_user_id", "is_sample") values ('215dcbc5-da43-4f1a-8e0d-7ff416c5ffba', 'https://wjvpjyvyavyapvrrmvjq.supabase.co/storage/v1/object/public/demo-assets/personal-development/b6abcbd88c58e85339fe1b8b98f0c78387af08710899f09402d750b99652bf83.webp', 'Wind Down', null, '2026-11-25T04:41:20.034323+00:00', '2026-11-25T05:40:35.264858+00:00', 'dc9b81c8-0d95-4fec-9aeb-7bdb5a3f36dc', true);
insert into demo_admin.pd_seed_libraries ("id", "image_url", "name", "subtitle", "created_at", "updated_at", "auth_user_id", "is_sample") values ('9394f7b2-447c-48d6-82df-1120a98bdee5', 'https://wjvpjyvyavyapvrrmvjq.supabase.co/storage/v1/object/public/demo-assets/personal-development/726bae20ba38c41b520c9bea2bece7e859cfe66fbece9f63b732989c0a85ac48.webp', 'Calm Breath', null, '2026-11-25T04:41:21.034323+00:00', '2026-11-25T05:40:35.264858+00:00', 'dc9b81c8-0d95-4fec-9aeb-7bdb5a3f36dc', true);
create table demo_admin.pd_seed_contents as select * from symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.contents with no data;
insert into demo_admin.pd_seed_contents ("id", "image_url", "name", "subtitle", "created_at", "updated_at", "auth_user_id", "is_sample") values ('6a67fbf6-c0be-454c-a841-1fe2bbb09c9d', null, 'Winding down', 'Day 1 · 15 min', '2026-11-25T04:41:19.034323+00:00', '2026-11-25T05:40:35.264858+00:00', 'dc9b81c8-0d95-4fec-9aeb-7bdb5a3f36dc', true);
insert into demo_admin.pd_seed_contents ("id", "image_url", "name", "subtitle", "created_at", "updated_at", "auth_user_id", "is_sample") values ('15421259-062f-4f14-bd77-1bfe971280a1', null, 'Quiet the mind', 'Day 2 · 15 min', '2026-11-25T04:41:20.034323+00:00', '2026-11-25T05:40:35.264858+00:00', 'dc9b81c8-0d95-4fec-9aeb-7bdb5a3f36dc', true);
insert into demo_admin.pd_seed_contents ("id", "image_url", "name", "subtitle", "created_at", "updated_at", "auth_user_id", "is_sample") values ('3feccd6e-18bc-482d-9132-34604e341530', null, 'Body scan for sleep', 'Day 3 · 14 min', '2026-11-25T04:41:21.034323+00:00', '2026-11-25T05:40:35.264858+00:00', 'dc9b81c8-0d95-4fec-9aeb-7bdb5a3f36dc', true);
create table demo_admin.pd_seed_settings as select * from symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.settings with no data;
insert into demo_admin.pd_seed_settings ("id", "image_url", "name", "photo_url", "created_at", "updated_at", "auth_user_id", "is_sample") values ('a13e0dca-eb80-4c95-a96a-3e3067170da4', 'https://wjvpjyvyavyapvrrmvjq.supabase.co/storage/v1/object/public/demo-assets/personal-development/b87ae7ade8783144db7b48e492b9cc74d95bd2600caea07552e8f8db28cb8881.webp', 'Privacy & data', null, '2026-11-25T04:41:19.034323+00:00', '2026-11-25T05:40:35.264858+00:00', 'dc9b81c8-0d95-4fec-9aeb-7bdb5a3f36dc', true);
insert into demo_admin.pd_seed_settings ("id", "image_url", "name", "photo_url", "created_at", "updated_at", "auth_user_id", "is_sample") values ('31fd6631-1bde-4b12-a403-124bf93f98a5', 'https://wjvpjyvyavyapvrrmvjq.supabase.co/storage/v1/object/public/demo-assets/personal-development/682719fe4918de790571fe469188a9718ba8fe11c9c1a01c3ce648b1e66b367c.webp', 'Log out', null, '2026-11-25T04:41:20.034323+00:00', '2026-11-25T05:40:35.264858+00:00', 'dc9b81c8-0d95-4fec-9aeb-7bdb5a3f36dc', true);

CREATE OR REPLACE FUNCTION demo_admin.reset_personal_development()
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  delete from symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.badges;
  delete from symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.check_ins;
  delete from symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.contents;
  delete from symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.goals;
  delete from symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.journal_entries;
  delete from symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.journeies;
  delete from symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.libraries;
  delete from symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.milestones;
  delete from symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.plans;
  delete from symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.profiles;
  delete from symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.settings;
  delete from symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.subscriptions;
  delete from symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.week1s;
  insert into symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.week1s select * from demo_admin.pd_seed_week1s order by created_at;
  insert into symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.libraries select * from demo_admin.pd_seed_libraries order by created_at;
  insert into symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.contents select * from demo_admin.pd_seed_contents order by created_at;
  insert into symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.settings select * from demo_admin.pd_seed_settings order by created_at;

  update auth.users set raw_user_meta_data = coalesce(raw_user_meta_data, '{}'::jsonb) || '{"full_name":"Yasas"}'::jsonb
   where id = 'dc9b81c8-0d95-4fec-9aeb-7bdb5a3f36dc';
  insert into symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.profiles (auth_user_id, display_name, email, notifications_enabled)
    values ('dc9b81c8-0d95-4fec-9aeb-7bdb5a3f36dc', 'Yasas Gunaratne', 'demo@symplr.io', true);
  insert into symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.check_ins (auth_user_id, kind, journey, day, day_name, mind, feel_now)
    values ('dc9b81c8-0d95-4fec-9aeb-7bdb5a3f36dc', 'pre', '21-Day Release', 4, 'Letting go', '["Tired","Hopeful","Restless","Grateful"]'::jsonb, 'Okay'),
           ('dc9b81c8-0d95-4fec-9aeb-7bdb5a3f36dc', 'post', '21-Day Release', 4, 'Letting go', null, 'Good');
  insert into symplr_c41f7c7a_de20_4401_a958_0892c920bfc7.journal_entries (auth_user_id, journey, day, day_name, prompt, body, entry_date, created_at)
    values ('dc9b81c8-0d95-4fec-9aeb-7bdb5a3f36dc', '21-Day Release', 4, 'Letting go',
            'What am I holding onto that I can’t control?',
            'I keep replaying the meeting from last week. I can’t change what was said, but I notice my chest tightens every time.' || chr(10) || chr(10) ||
            'If I let it go, I think I’d feel lighter and more present with my family tonight. Tomorrow I will try one slow breath before I open my email.',
            to_char(current_date, 'YYYY-MM-DD'), now()),
           ('dc9b81c8-0d95-4fec-9aeb-7bdb5a3f36dc', '21-Day Release', 3, 'The body’s signal', 'Where do I feel stress?',
            'My shoulders hold everything. When I slowed my breathing I noticed them drop.',
            to_char(current_date - 1, 'YYYY-MM-DD'), now() - interval '1 day'),
           ('dc9b81c8-0d95-4fec-9aeb-7bdb5a3f36dc', '21-Day Release', 2, 'Naming the thought', 'What story am I telling?',
            'The story is that I am behind. But behind whom, and by what measure?',
            to_char(current_date - 11, 'YYYY-MM-DD'), now() - interval '11 days');
end $function$
;
revoke all on function demo_admin.reset_personal_development() from public, anon, authenticated;
select demo_admin.reset_personal_development();
select cron.schedule('personal-development-reset', '*/30 * * * *', 'select demo_admin.reset_personal_development()');
