-- ============================================================
--  Cue  --  Supabase Schema
--  Run this in the SQL editor of your Supabase project.
--  Auth is handled by Supabase (auth.users); all tables
--  reference auth.users(id) and are protected by RLS.
-- ============================================================


-- ------------------------------------------------------------
--  onboarding_profiles
--  Stores quiz answers collected during first-launch onboarding.
-- ------------------------------------------------------------
create table if not exists public.onboarding_profiles (
    id                      uuid        primary key default gen_random_uuid(),
    user_id                 uuid        references auth.users(id) on delete cascade not null unique,
    display_name            text,
    gender                  text,
    skin_type               text,
    skin_concerns           text[],
    concern_severity        integer     check (concern_severity between 1 and 5),
    concern_duration        text,
    age_range               text,
    skincare_routine        text,
    consistency             text,
    lifestyle_factors       text[],
    sensitivity_level       text,
    primary_goal            text,
    onboarding_completed_at timestamptz,
    created_at              timestamptz default now() not null,
    updated_at              timestamptz default now() not null
);

alter table public.onboarding_profiles enable row level security;

create policy "Users manage own onboarding profile"
    on public.onboarding_profiles
    using  (auth.uid() = user_id)
    with check (auth.uid() = user_id);


-- ------------------------------------------------------------
--  skin_profiles
--  Active skin type / concern list, serialised as JSON blob.
-- ------------------------------------------------------------
create table if not exists public.skin_profiles (
    id         uuid        primary key default gen_random_uuid(),
    user_id    uuid        references auth.users(id) on delete cascade not null unique,
    data_json  text        not null,
    created_at timestamptz default now() not null,
    updated_at timestamptz default now() not null
);

alter table public.skin_profiles enable row level security;

create policy "Users manage own skin profile"
    on public.skin_profiles
    using  (auth.uid() = user_id)
    with check (auth.uid() = user_id);


-- ------------------------------------------------------------
--  scan_results
--  Product ingredient scans (OCR text + parsed ingredients).
-- ------------------------------------------------------------
create table if not exists public.scan_results (
    id               uuid        primary key,
    user_id          uuid        references auth.users(id) on delete cascade not null,
    product_name     text,
    raw_ocr_text     text        not null,
    ingredients_json text        not null,
    image_filename   text,
    created_at       timestamptz not null
);

alter table public.scan_results enable row level security;

create policy "Users manage own scan results"
    on public.scan_results
    using  (auth.uid() = user_id)
    with check (auth.uid() = user_id);

create index if not exists scan_results_user_created
    on public.scan_results (user_id, created_at desc);


-- ------------------------------------------------------------
--  trigger_logs
--  Daily diary entries (skin condition, food, sleep, stress…).
-- ------------------------------------------------------------
create table if not exists public.trigger_logs (
    id        uuid        primary key,
    user_id   uuid        references auth.users(id) on delete cascade not null,
    date      timestamptz not null,
    data_json text        not null
);

alter table public.trigger_logs enable row level security;

create policy "Users manage own trigger logs"
    on public.trigger_logs
    using  (auth.uid() = user_id)
    with check (auth.uid() = user_id);

create index if not exists trigger_logs_user_date
    on public.trigger_logs (user_id, date desc);


-- ------------------------------------------------------------
--  insights
--  AI-generated correlations (sleep/food/product → breakout).
-- ------------------------------------------------------------
create table if not exists public.insights (
    id               uuid             primary key default gen_random_uuid(),
    user_id          uuid             references auth.users(id) on delete cascade not null,
    type             text             not null,
    title            text             not null,
    body             text             not null,
    confidence       double precision not null,
    days_to_breakout integer,
    created_at       timestamptz      default now() not null
);

alter table public.insights enable row level security;

create policy "Users manage own insights"
    on public.insights
    using  (auth.uid() = user_id)
    with check (auth.uid() = user_id);

create index if not exists insights_user_created
    on public.insights (user_id, created_at desc);


-- ------------------------------------------------------------
--  fcm_tokens
--  One row per user per platform; upserted on every launch.
-- ------------------------------------------------------------
create table if not exists public.fcm_tokens (
    user_id    uuid        references auth.users(id) on delete cascade not null,
    token      text        not null,
    platform   text        not null default 'ios',
    updated_at timestamptz default now() not null,
    primary key (user_id, platform)
);

alter table public.fcm_tokens enable row level security;

create policy "Users manage own FCM tokens"
    on public.fcm_tokens
    using  (auth.uid() = user_id)
    with check (auth.uid() = user_id);
