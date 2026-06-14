-- HUSTLE TRACKER — Schema v1

-- Teams
create table if not exists ht_teams (
  id         text primary key,
  user_id    uuid references auth.users not null,
  name       text not null,
  players    jsonb not null default '[]',
  actions    jsonb not null default '[]',
  created_at bigint
);
alter table ht_teams enable row level security;
create policy "owner" on ht_teams for all using (auth.uid() = user_id);

-- Sessions
create table if not exists ht_sessions (
  id               text primary key,
  user_id          uuid references auth.users not null,
  team_id          text references ht_teams(id) on delete cascade,
  type             text not null,
  date             text not null,
  name             text,
  active_players   jsonb not null default '[]',
  stats            jsonb not null default '{}',
  history          jsonb not null default '[]',
  status           text not null default 'live',
  created_at       bigint,
  completed_at     bigint
);
alter table ht_sessions enable row level security;
create policy "owner" on ht_sessions for all using (auth.uid() = user_id);
