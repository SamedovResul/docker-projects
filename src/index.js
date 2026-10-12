import express from 'express';
import pg from 'pg';


const app = express();
const PORT = 3000;

const { Pool } = pg;

const pool = new Pool({
  connectionString: process.env.DATABASE_URL
});

app.get('/', (req, res) => {
  res.send('Hello World');
});

app.get('/db', async (req, res) => {
  try {
    const result = await pool.query('SELECT NOW()');
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
