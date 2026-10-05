# SportBet Demo
Educational sports-betting simulation. No real-money deposits, withdrawals, or wagering.

## Run
1. Install Node.js 20+ and PostgreSQL.
2. Create database/user and run `psql "$DATABASE_URL" -f db/schema.sql`.
3. Copy `.env.example` to `.env` and set a strong JWT_SECRET.
4. `npm install`
5. `npm start`
6. Open http://localhost:3000

API: `/api/health`, `/api/register`, `/api/login`, `/api/matches`, `/api/bets`.
Admin endpoints require a database user whose role is `admin`.
