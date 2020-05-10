var config = require('../../../config/init');
const bcrypt = require('bcrypt');

function registerNewUser(data, error, success) {

   const { email, password } = data;
  
    bcrypt.hash(password, config.saltRounds, function(err, hashPassword) {
        config.dbPool.query('INSERT INTO users (email, password) VALUES ($1, $2)', 
          [email, hashPassword], (fail, results) => {
            if (fail) {
                error(fail.detail);
                return;
            }
            success();
        });  
    });

}

module.exports = {
    registerNewUser,
}