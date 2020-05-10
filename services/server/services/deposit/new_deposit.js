var config = require('../../../config/init');
var jwt = require('jsonwebtoken');

function deposit(data, error, success) {
    jwt.verify(data.headers.token, config.tokenKey.key, function(err, decoded) {
        if(decoded) {
            const {user_id, deposit_name, amount, interest_rate, source_account_id, interest_payments, date_time, end_date} = data.body;
            config.dbPool.query('SELECT id FROM users WHERE email=$1 AND password=$2;', 
            [decoded.email, decoded.password], (fail, results) => {
                if(results.rowCount > 0) {
                    config.dbPool.query('CALL new_deposit($1, $2, $3, $4, $5, $6, $7, $8);', 
                    [user_id, deposit_name, amount, interest_rate, source_account_id, interest_payments, date_time, end_date], (fail, results) => {
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
    deposit
}


