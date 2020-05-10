var config = require('../../../config/init');
var jwt = require('jsonwebtoken');


function newScore(data, error, success) {
    jwt.verify(data.headers.token, config.tokenKey.key, function(err, decoded) {
        if(decoded) {
            const {scoreName, balance, currency} = data.body;
                config.dbPool.query('SELECT id FROM users WHERE email=$1 AND password=$2;', 
                [decoded.email, decoded.password], (fail, results) => {
                    if(results.rowCount > 0) {
                        config.dbPool.query('INSERT INTO accounts (account_name, balance, currency, user_id) VALUES ($1, $2, $3, $4) RETURNING id;', 
                        [scoreName, balance, currency, results.rows[0].id], (fail, results) => {
                            if(results.rowCount > 0) {
                                success(results.rows[0].id);
                            } else {
                                error();
                            }
                            if (fail) {
                                error(fail.detail);
                                return;
                            }
                        });
                    } else {
                        error();
                    }
                    if (fail) {
                        error(fail.detail);
                        return;
                    }
                });
        }
        if(err) {
            error(err);
        }
    });
}

module.exports = {
    newScore,
}