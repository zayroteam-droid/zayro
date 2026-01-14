const pool = require('../utils/db');

const createUser = async (name, email, password_hash) => {
  const res = await pool.query(
    'INSERT INTO users (name, email, password_hash) VALUES ($1, $2, $3) RETURNING *',
    [name, email, password_hash]
  );
  return res.rows[0];
};

const getUserByEmail = async (email) => {
  const res = await pool.query('SELECT * FROM users WHERE email=$1', [email]);
  return res.rows[0];
};

module.exports = { createUser, getUserByEmail };
