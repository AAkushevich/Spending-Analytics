var config = require('../../../config/init');
var jwt = require('jsonwebtoken');

function credit(data, error, success) {
    jwt.verify(data.headers.token, config.tokenKey.key, function(err, decoded) {
        if(decoded) {
            const {date_time, end_date, amount, interest_rate, credit_name, target_account_id, credit_payments} = data.body;
            config.dbPool.query('SELECT id FROM users WHERE email=$1 AND password=$2;', 
            [decoded.email, decoded.password], (fail, results) => {
                if(results.rowCount > 0) {
                    let user_id = results.rows[0].id;
                    console.log(user_id);
                    config.dbPool.query('CALL new_credit($1, $2, $3, $4, $5, $6, $7, $8);', 
                    [user_id, date_time, end_date, amount, interest_rate, credit_name, target_account_id, credit_payments], 
                    (fail, results) => {
                        if (fail) {
                            error(fail.detail);
                            return;
                        }

                        config.dbPool.query('select get_last_operation_id($1);', 
                            [user_id], (fails, results) => {
                                if(fails) {
                                    error(fails.detail);
                                }
                                success(results.rows[0].get_last_operation_id);
                        });

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
    credit,
}


