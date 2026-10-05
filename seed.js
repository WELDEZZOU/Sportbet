require('dotenv').config();
const {Pool}=require('pg'); const bcrypt=require('bcryptjs');
const pool=new Pool({connectionString:process.env.DATABASE_URL});
(async()=>{const c=await pool.connect();try{
 await c.query('TRUNCATE demo_bet_legs,demo_bets,odds,matches,users RESTART IDENTITY CASCADE');
 const u=await bcrypt.hash('demo123',10), a=await bcrypt.hash('admin123',10);
 await c.query('INSERT INTO users(email,password_hash,role) VALUES($1,$2,$3),($4,$5,$6)', ['demo@sportbet.test',u,'user','admin@sportbet.test',a,'admin']);
 const now=new Date(), rows=[
  ['Football','Demo Champions','Barcelona','Sevilla',new Date(now.getTime()+86400000),'scheduled',0,0,0],
  ['Football','Demo League','Bayern Munich','RB Leipzig',new Date(now.getTime()+2*86400000),'scheduled',0,0,0],
  ['Football','Demo Live','Real Madrid','Valencia',new Date(now.getTime()-35*60000),'live',2,1,35],
  ['Basketball','Demo Basketball','Lakers','Celtics',new Date(now.getTime()-20*60000),'live',58,55,20],
  ['Tennis','Demo Tennis','Player A','Player B',new Date(now.getTime()+3*86400000),'scheduled',0,0,0],
  ['Football','Demo Finished','Milan','Inter',new Date(now.getTime()-86400000),'finished',1,0,90]
 ];
 for(const r of rows){const q=await c.query(`INSERT INTO matches(sport,league,home_team,away_team,starts_at,status,home_score,away_score,minute) VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9) RETURNING id`,r);const id=q.rows[0].id;
  if(r[5]!=='finished') {const prices=r[0]==='Tennis'?[['HOME','1.80'],['AWAY','2.10']]:[['HOME','1.90'],['DRAW','3.40'],['AWAY','3.80']]; for(const [s,p] of prices) await c.query('INSERT INTO odds(match_id,selection,price) VALUES($1,$2,$3)',[id,s,p]);}
 }
 console.log('Seed complete. Demo: demo@sportbet.test / demo123 | Admin: admin@sportbet.test / admin123');
}finally{c.release(); await pool.end()}})().catch(e=>{console.error(e);process.exit(1)});
