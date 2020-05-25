var jwtToken = require('./../../token/jwtToken');
var config = require('./../../../config/init');
const bcrypt = require('bcrypt');

function login(data, errorEvent, success) {
  const { email, password } = data;

  config.dbPool.query('SELECT password FROM users WHERE email=$1;', [email], (error, results) => {

    if (error) {
        errorEvent(error);
    }
    
    if(results.rowCount > 0) {
    bcrypt.compare(password, results.rows[0].password, function(err, result) {
        if(result) {
            let jwtoken = jwtToken.getToken(email, results.rows[0].password);
            success(jwtoken);
        } else {
            errorEvent();
        }
    });
    } else {
        errorEvent();
    }

  });
}

module.exports = {
    login: login
};
