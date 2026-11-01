-- SQLite schema snapshot after integrating upstream v0.5.0 (f6cee74b), 2026-11-01.
-- 70 application tables, including lazily initialized story corpus and embedded texts.
-- Captured from an isolated temporary database; no deployment data.

CREATE TABLE achievement_progress (
    user_id TEXT NOT NULL REFERENCES users(id),
    achievement TEXT NOT NULL,
    character_id TEXT NOT NULL,
    count INTEGER NOT NULL,
    last_day TEXT,
    PRIMARY KEY (user_id, achievement, character_id)
);
CREATE TABLE achievement_stages (
    user_id TEXT NOT NULL REFERENCES users(id),
    achievement TEXT NOT NULL,
    character_id TEXT NOT NULL,
    stage INTEGER NOT NULL,
    unlocked_at TEXT NOT NULL,
    PRIMARY KEY (user_id, achievement, character_id, stage)
);
CREATE TABLE achievements_launched (
    id INTEGER PRIMARY KEY CHECK (id = 1),
    launched_at TEXT NOT NULL
);
CREATE TABLE activity_records (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    kind TEXT NOT NULL,
    user_id TEXT REFERENCES users(id),
    anonymous_id TEXT,
    character_id TEXT NOT NULL,
    started_at REAL NOT NULL,
    result TEXT NOT NULL,
    own_keys INTEGER NOT NULL DEFAULT 0,
    time_to_speak_ms REAL,
    call_id INTEGER,
    duration_s REAL,
    end_reason TEXT,
    affinity_level INTEGER,
    out_of_line INTEGER,
    manipulation INTEGER,
    cooled INTEGER,
    ended_conversation TEXT,
    answered INTEGER NOT NULL DEFAULT 0,
    degraded TEXT
);
CREATE TABLE affinities (
    user_id TEXT NOT NULL REFERENCES users(id),
    character_id TEXT NOT NULL,
    value REAL NOT NULL,
    updated_at TEXT NOT NULL,
    cooling INTEGER NOT NULL DEFAULT 0,
    gained_today REAL NOT NULL DEFAULT 0,
    gained_on TEXT,
    considerate_today REAL NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id, character_id)
);
CREATE TABLE announcements (
    id TEXT PRIMARY KEY,
    body TEXT NOT NULL,
    published_at TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    pinned INTEGER NOT NULL DEFAULT 0
);
CREATE TABLE backup_runs (
    id INTEGER PRIMARY KEY,
    source TEXT NOT NULL,
    started_at TEXT NOT NULL,
    finished_at TEXT,
    abandoned INTEGER NOT NULL DEFAULT 0,
    exit_code INTEGER,
    key TEXT,
    size INTEGER,
    kept INTEGER,
    total INTEGER,
    over_warning INTEGER NOT NULL DEFAULT 0,
    config_error TEXT,
    export_error TEXT,
    upload_error TEXT,
    prune_error TEXT
);
CREATE TABLE banned_identities (
    identity_hash TEXT PRIMARY KEY,
    added_at TEXT NOT NULL
);
CREATE TABLE call_rollups (
    start INTEGER NOT NULL,
    service TEXT NOT NULL,
    provider TEXT NOT NULL,
    model TEXT NOT NULL,
    own_key INTEGER NOT NULL,
    error TEXT NOT NULL,
    usage_unit TEXT NOT NULL,
    input_told INTEGER NOT NULL,
    output_told INTEGER NOT NULL,
    stripped_tags TEXT NOT NULL,
    first_at REAL NOT NULL,
    calls INTEGER NOT NULL,
    usage_input REAL,
    usage_output REAL,
    usage_cached REAL,
    PRIMARY KEY (start, service, provider, model, own_key, error, usage_unit, input_told,
                 output_told, stripped_tags)
) WITHOUT ROWID;
CREATE TABLE calls (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    conversation_id TEXT NOT NULL REFERENCES conversations(id),
    connected_at TEXT NOT NULL,
    duration_s REAL NOT NULL
);
CREATE TABLE config_overrides (
    name TEXT PRIMARY KEY,
    value TEXT NOT NULL,
    last4 TEXT,
    updated_at TEXT NOT NULL
);
CREATE TABLE conversation_events (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    conversation_id TEXT NOT NULL REFERENCES conversations(id),
    kind TEXT NOT NULL,
    created_at TEXT NOT NULL,
    affinity TEXT,
    gift_id TEXT,
    liked INTEGER NOT NULL DEFAULT 0,
    first_day TEXT,
    days_ago INTEGER
);
CREATE TABLE conversations (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL REFERENCES users(id),
    character_id TEXT NOT NULL,
    created_at TEXT NOT NULL,
    title TEXT
);
CREATE TABLE cycle_records (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL REFERENCES users(id),
    character_id TEXT NOT NULL,
    first_day TEXT NOT NULL,
    days INTEGER NOT NULL,
    recorded_at TEXT NOT NULL
);
CREATE TABLE cycles_off (
    user_id TEXT PRIMARY KEY REFERENCES users(id)
);
CREATE TABLE data_package_imports (
    user_id TEXT NOT NULL,
    at TEXT NOT NULL
);
CREATE TABLE embedded_texts (
    scope TEXT NOT NULL,
    text TEXT NOT NULL,
    model TEXT NOT NULL,
    embedding BLOB NOT NULL,
    PRIMARY KEY (scope, model, text)
);
CREATE TABLE episode_cast (
    episode_id TEXT NOT NULL REFERENCES episodes(id) ON DELETE CASCADE,
    character_id TEXT NOT NULL,
    PRIMARY KEY (episode_id, character_id)
);
CREATE TABLE episode_lines (
    episode_id TEXT NOT NULL REFERENCES episodes(id) ON DELETE CASCADE,
    seq INTEGER NOT NULL,
    speaker TEXT,
    ja TEXT NOT NULL,
    zh TEXT,
    PRIMARY KEY (episode_id, seq)
);
CREATE TABLE episode_passages (
    episode_id TEXT NOT NULL REFERENCES episodes(id) ON DELETE CASCADE,
    seq INTEGER NOT NULL,
    text TEXT NOT NULL,
    model TEXT NOT NULL,
    embedding BLOB NOT NULL,
    PRIMARY KEY (episode_id, seq)
);
CREATE TABLE episodes (
    id TEXT PRIMARY KEY,
    category TEXT NOT NULL,
    source TEXT NOT NULL,
    title TEXT NOT NULL,
    imported_from TEXT NOT NULL DEFAULT 'csv',
    imported_at TEXT NOT NULL
);
CREATE TABLE gift_backpacks (
    user_id TEXT NOT NULL REFERENCES users(id),
    gift_id TEXT NOT NULL,
    count INTEGER NOT NULL,
    PRIMARY KEY (user_id, gift_id)
);
CREATE TABLE gift_balances (
    user_id TEXT PRIMARY KEY REFERENCES users(id),
    draws INTEGER NOT NULL,
    given_on TEXT NOT NULL,
    reset_cards INTEGER NOT NULL DEFAULT 0
);
CREATE TABLE gift_rewards (
    user_id TEXT NOT NULL REFERENCES users(id),
    key TEXT NOT NULL,
    draws INTEGER NOT NULL,
    reset_cards INTEGER NOT NULL,
    rewarded_at TEXT NOT NULL,
    PRIMARY KEY (user_id, key)
);
CREATE TABLE gifts_opened (
    id INTEGER PRIMARY KEY CHECK (id = 1),
    open INTEGER NOT NULL,
    opened_at TEXT
);
CREATE TABLE invited_users (
    user_id TEXT PRIMARY KEY REFERENCES users(id),
    invite_id INTEGER NOT NULL REFERENCES invites(id)
);
CREATE TABLE invites (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT NOT NULL UNIQUE,
    note TEXT,
    max_uses INTEGER NOT NULL,
    used INTEGER NOT NULL DEFAULT 0,
    expires_at TEXT,
    created_at TEXT NOT NULL
);
CREATE TABLE letter_users (
    user_id TEXT PRIMARY KEY REFERENCES users(id),
    planned_day TEXT NOT NULL
);
CREATE TABLE letter_voices (
    letter_id INTEGER NOT NULL REFERENCES letters(id),
    block INTEGER NOT NULL,
    mp3 BLOB NOT NULL,
    PRIMARY KEY (letter_id, block)
);
CREATE TABLE letters (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT NOT NULL REFERENCES users(id),
    character_id TEXT NOT NULL,
    occasions TEXT NOT NULL,
    day TEXT NOT NULL,
    written_at TEXT NOT NULL,
    salutation TEXT NOT NULL,
    paragraphs TEXT NOT NULL,
    read_at TEXT,
    popped_at TEXT,
    record_id INTEGER
);
CREATE TABLE letters_due (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT NOT NULL REFERENCES users(id),
    character_id TEXT NOT NULL,
    occasion TEXT NOT NULL,
    day TEXT NOT NULL,
    due_at TEXT NOT NULL,
    attempts INTEGER NOT NULL DEFAULT 0
);
CREATE TABLE memories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT NOT NULL REFERENCES users(id),
    source_character_id TEXT NOT NULL,
    conversation_id TEXT REFERENCES conversations(id),
    text TEXT NOT NULL,
    created_at TEXT NOT NULL,
    superseded_by INTEGER,
    UNIQUE (user_id, text)
);
CREATE TABLE memory_vectors (
    memory_id INTEGER NOT NULL,
    user_id TEXT NOT NULL,
    model TEXT NOT NULL,
    embedding BLOB NOT NULL,
    PRIMARY KEY (memory_id, model)
);
CREATE TABLE messages (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    conversation_id TEXT NOT NULL REFERENCES conversations(id),
    role TEXT NOT NULL CHECK (role IN ('user', 'character')),
    text TEXT,
    ja TEXT,
    zh TEXT,
    segments TEXT,
    created_at TEXT NOT NULL,
    affinity TEXT,
    hurt REAL,
    out_of_line INTEGER
);
CREATE TABLE moment_circle (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    moment_id INTEGER NOT NULL REFERENCES moments(id),
    character_id TEXT NOT NULL,
    kind TEXT NOT NULL,
    ja TEXT,
    zh TEXT,
    position INTEGER NOT NULL,
    shown_at TEXT NOT NULL
);
CREATE TABLE moment_comments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    moment_id INTEGER NOT NULL UNIQUE REFERENCES moments(id),
    text TEXT NOT NULL,
    commented_at TEXT NOT NULL,
    reply_at TEXT,
    reply_ja TEXT,
    reply_zh TEXT
);
CREATE TABLE moment_images (
    moment_id INTEGER PRIMARY KEY REFERENCES moments(id),
    image BLOB NOT NULL
);
CREATE TABLE moment_likes (
    moment_id INTEGER PRIMARY KEY REFERENCES moments(id)
);
CREATE TABLE moment_plans (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT NOT NULL REFERENCES users(id),
    character_id TEXT NOT NULL,
    day TEXT NOT NULL,
    due_at TEXT NOT NULL,
    kind TEXT NOT NULL,
    birthday INTEGER NOT NULL
);
CREATE TABLE moment_users (
    user_id TEXT PRIMARY KEY REFERENCES users(id),
    planned_day TEXT,
    opened_at TEXT
);
CREATE TABLE moments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT NOT NULL REFERENCES users(id),
    character_id TEXT NOT NULL,
    ja TEXT NOT NULL,
    zh TEXT NOT NULL,
    image TEXT,
    place_id TEXT,
    place_name TEXT,
    place_lat REAL,
    place_lon REAL,
    weather TEXT,
    temperature INTEGER,
    day TEXT NOT NULL,
    posted_at TEXT NOT NULL
);
CREATE TABLE moments_off (
    user_id TEXT PRIMARY KEY REFERENCES users(id)
);
CREATE TABLE photos (
    id TEXT PRIMARY KEY,
    conversation_id TEXT NOT NULL REFERENCES conversations(id),
    message_id INTEGER NOT NULL UNIQUE REFERENCES messages(id),
    tag TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('pending', 'ready', 'failed')),
    reason TEXT,
    image BLOB,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
);
CREATE TABLE price_catalog (
    provider TEXT NOT NULL,
    model TEXT NOT NULL,
    input REAL NOT NULL,
    output REAL,
    cache_read REAL,
    PRIMARY KEY (provider, model)
);
CREATE TABLE price_catalog_hosts (
    host TEXT NOT NULL,
    provider TEXT NOT NULL,
    PRIMARY KEY (host, provider)
);
CREATE TABLE price_catalog_offers (
    provider TEXT NOT NULL,
    model TEXT NOT NULL,
    name TEXT NOT NULL,
    protocol TEXT NOT NULL,
    base_url TEXT NOT NULL,
    PRIMARY KEY (provider, model)
);
CREATE TABLE price_catalog_providers (
    provider TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    protocol TEXT,
    base_url TEXT
);
CREATE TABLE price_catalog_state (
    id INTEGER PRIMARY KEY CHECK (id = 1),
    fetched_at TEXT,
    failed_at TEXT,
    error TEXT
);
CREATE TABLE price_catalog_thinking (
    provider TEXT NOT NULL,
    model TEXT NOT NULL,
    thinks INTEGER NOT NULL,
    efforts TEXT NOT NULL, -- separated by spaces
    switch INTEGER NOT NULL,
    PRIMARY KEY (provider, model)
);
CREATE TABLE price_overrides (
    provider TEXT NOT NULL,
    model TEXT NOT NULL,
    unit TEXT NOT NULL,
    input REAL NOT NULL,
    output REAL,
    currency TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    cache_read REAL,
    PRIMARY KEY (provider, model, unit)
);
CREATE TABLE producer_profiles (
    user_id TEXT PRIMARY KEY REFERENCES users(id),
    form_of_address TEXT,
    gender TEXT,
    timezone TEXT,
    updated_at TEXT NOT NULL,
    birthday_month INTEGER,
    birthday_day INTEGER,
    -- Where the producer is, as QWeather found it (`producer.City`): NULL for nowhere set.
    city_name TEXT,
    city_adm2 TEXT,
    city_adm1 TEXT,
    city_country TEXT,
    city_latitude REAL,
    city_longitude REAL
);
CREATE TABLE reach_out_schedules (
    conversation_id TEXT PRIMARY KEY REFERENCES conversations(id),
    contact_at TEXT NOT NULL,
    place REAL NOT NULL,
    morning_place REAL,
    due_at TEXT
);
CREATE TABLE reach_outs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    conversation_id TEXT NOT NULL REFERENCES conversations(id),
    ja TEXT NOT NULL,
    zh TEXT NOT NULL,
    segments TEXT NOT NULL,
    created_at TEXT NOT NULL,
    seen INTEGER NOT NULL DEFAULT 0,
    record_id INTEGER
);
CREATE TABLE reach_outs_off (
    user_id TEXT PRIMARY KEY REFERENCES users(id)
);
CREATE TABLE record_rollups (
    length INTEGER NOT NULL,
    start INTEGER NOT NULL,
    kind TEXT NOT NULL,
    character_id TEXT NOT NULL,
    result TEXT NOT NULL,
    own_keys INTEGER NOT NULL,
    in_call INTEGER NOT NULL,
    end_reason TEXT NOT NULL,
    affinity_level INTEGER NOT NULL,
    out_of_line INTEGER NOT NULL,
    manipulation INTEGER NOT NULL,
    cooled INTEGER NOT NULL,
    ended INTEGER NOT NULL,
    answered INTEGER NOT NULL,
    count INTEGER NOT NULL,
    PRIMARY KEY (length, start, kind, character_id, result, own_keys, in_call, end_reason,
                 affinity_level, out_of_line, manipulation, cooled, ended, answered)
) WITHOUT ROWID;
CREATE TABLE reset_card_grants (
    granted_at TEXT NOT NULL,
    count INTEGER NOT NULL
);
CREATE TABLE schedule_placements (
    user_id TEXT NOT NULL REFERENCES users(id),
    week TEXT NOT NULL,
    job_id TEXT NOT NULL REFERENCES weekly_jobs(id),
    day INTEGER NOT NULL,
    slot INTEGER NOT NULL,
    saved_at TEXT NOT NULL,
    counted_at TEXT,
    PRIMARY KEY (user_id, week, job_id)
);
CREATE TABLE service_calls (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    record_id INTEGER,
    at REAL NOT NULL,
    service TEXT NOT NULL,
    provider TEXT NOT NULL,
    model TEXT NOT NULL,
    own_key INTEGER NOT NULL DEFAULT 0,
    error TEXT,
    latency_ms REAL,
    usage_unit TEXT,
    usage_input REAL,
    usage_output REAL,
    first_token_ms REAL,
    reasoning_effort TEXT,
    usage_cached REAL,
    stripped_tags TEXT
);
CREATE TABLE sessions (
    token_hash TEXT PRIMARY KEY,
    user_id TEXT NOT NULL REFERENCES users(id),
    last_active_at REAL NOT NULL,
    expires_at REAL NOT NULL
);
CREATE TABLE sign_in_methods (
    user_id TEXT NOT NULL REFERENCES users(id),
    provider TEXT NOT NULL,
    subject TEXT NOT NULL,
    display_name TEXT NOT NULL,
    email TEXT,
    created_at TEXT NOT NULL,
    UNIQUE (provider, subject)
);
CREATE TABLE sponsor (
    id INTEGER PRIMARY KEY CHECK (id = 1),
    enabled INTEGER NOT NULL DEFAULT 0,
    image BLOB,
    image_at TEXT
);
CREATE TABLE spread_rollups (
    length INTEGER NOT NULL,
    start INTEGER NOT NULL,
    measure TEXT NOT NULL,
    service TEXT NOT NULL,
    own_key INTEGER NOT NULL,
    bucket INTEGER NOT NULL,
    count INTEGER NOT NULL,
    least REAL NOT NULL,
    most REAL NOT NULL,
    PRIMARY KEY (length, start, measure, service, own_key, bucket)
) WITHOUT ROWID;
CREATE TABLE story_corpus_version (
    id INTEGER PRIMARY KEY CHECK (id = 1),
    version INTEGER NOT NULL
);
CREATE TABLE taken_rollups (
    start INTEGER PRIMARY KEY,
    turns INTEGER NOT NULL,
    calls INTEGER NOT NULL
);
CREATE TABLE usage (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT NOT NULL REFERENCES users(id),
    kind TEXT NOT NULL,
    at REAL NOT NULL,
    exempt INTEGER NOT NULL DEFAULT 0
);
CREATE TABLE user_limits (
    user_id TEXT PRIMARY KEY REFERENCES users(id),
    turns_per_hour INTEGER,
    calls_per_hour INTEGER,
    note TEXT,
    updated_at TEXT NOT NULL,
    photos_per_hour INTEGER,
    visits_per_hour INTEGER,
    read_alouds_per_hour INTEGER
);
CREATE TABLE user_rollups (
    length INTEGER NOT NULL,
    start INTEGER NOT NULL,
    who TEXT NOT NULL,
    cooled INTEGER NOT NULL,
    PRIMARY KEY (length, start, who)
) WITHOUT ROWID;
CREATE TABLE users (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    created_at TEXT NOT NULL,
    consented_at TEXT,
    banned_at TEXT,
    ban_note TEXT
);
CREATE TABLE visit_records (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT NOT NULL REFERENCES users(id),
    character_id TEXT NOT NULL,
    entered_at TEXT NOT NULL,
    left_at TEXT NOT NULL,
    entered_on TEXT NOT NULL,
    reason TEXT NOT NULL,
    topic TEXT NOT NULL,
    orders TEXT NOT NULL,
    drunk INTEGER NOT NULL,
    rewarded INTEGER NOT NULL
);
CREATE TABLE weekly_jobs (
    id TEXT PRIMARY KEY,
    week TEXT NOT NULL,
    position INTEGER NOT NULL,
    character_id TEXT NOT NULL,
    listed_id TEXT NOT NULL,
    name TEXT NOT NULL,
    note TEXT NOT NULL,
    category TEXT NOT NULL,
    length INTEGER NOT NULL,
    slots TEXT
);
