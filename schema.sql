CREATE TABLE IF NOT EXISTS users (
 id SERIAL PRIMARY KEY,
 email TEXT UNIQUE NOT NULL,
 password_hash TEXT NOT NULL,
 role TEXT NOT NULL DEFAULT 'user' CHECK(role IN ('user','admin')),
 demo_balance NUMERIC(12,2) NOT NULL DEFAULT 10000 CHECK(demo_balance >= 0),
 created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS matches (
 id SERIAL PRIMARY KEY,
 sport TEXT NOT NULL DEFAULT 'Football',
 league TEXT NOT NULL DEFAULT 'Demo League',
 home_team TEXT NOT NULL,
 away_team TEXT NOT NULL,
 starts_at TIMESTAMPTZ NOT NULL,
 status TEXT NOT NULL DEFAULT 'scheduled' CHECK(status IN ('scheduled','live','finished')),
 home_score INT NOT NULL DEFAULT 0,
 away_score INT NOT NULL DEFAULT 0,
 minute INT NOT NULL DEFAULT 0,
 created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS odds (
 id SERIAL PRIMARY KEY,
 match_id INT NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
 market TEXT NOT NULL DEFAULT '1X2',
 selection TEXT NOT NULL,
 price NUMERIC(8,2) NOT NULL CHECK(price > 1),
 UNIQUE(match_id, market, selection)
);
CREATE TABLE IF NOT EXISTS demo_bets (
 id SERIAL PRIMARY KEY,
 user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
 stake NUMERIC(12,2) NOT NULL CHECK(stake > 0),
 potential_return NUMERIC(12,2) NOT NULL,
 status TEXT NOT NULL DEFAULT 'open' CHECK(status IN ('open','won','lost','void')),
 created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS demo_bet_legs (
 id SERIAL PRIMARY KEY,
 bet_id INT NOT NULL REFERENCES demo_bets(id) ON DELETE CASCADE,
 match_id INT NOT NULL REFERENCES matches(id),
 selection TEXT NOT NULL,
 price NUMERIC(8,2) NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_matches_status_start ON matches(status, starts_at);
CREATE INDEX IF NOT EXISTS idx_bets_user ON demo_bets(user_id, created_at DESC);
