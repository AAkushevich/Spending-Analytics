var config = require('../../../config/init');
var jwt = require('jsonwebtoken');

function income(data, error, success) {
    jwt.verify(data.headers.token, config.tokenKey.key, function(err, decoded) {
        if(decoded) {
            const {user_id, date_time, amount, account_id, category_id} = data.body;

            config.dbPool.query('SELECT id FROM users WHERE email=$1 AND password=$2;', 
            [decoded.email, decoded.password], (fail, results) => {
                if(results.rowCount > 0) {
                    config.dbPool.query('CALL new_income($1, $2, $3, $4, $5);', 
                    [user_id, date_time, amount, account_id, category_id], (fail, results) => {
                        if(results) {
                            success();
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
    income,
}