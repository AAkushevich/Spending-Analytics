const Pool = require('pg').Pool
const pool = new Pool({
  user: 'andrey',
  host: 'localhost',
  database: 'spa_db',
  password: 'qwerty',
  port: 5432,
})

const createUser = (request, response) => {
  const { email, password } = request.body;

  pool.query('INSERT INTO users (email, password) VALUES ($1, $2)', [email, password], (error, results) => {
    if (error) {
      throw error
    }
    response.status(200).send(`User added with ID: ${result.insertId}`)
  });
}


module.exports = {
  getUsers,
  getUserById,
  createUser,
  updateUser,
  deleteUser,
}