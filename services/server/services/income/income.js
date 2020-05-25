var config = require('../../../config/init');
var jwt = require('jsonwebtoken');

function income(data, error, success) {
    jwt.verify(data.headers.token, config.tokenKey.key, function(err, decoded) {
        if(decoded) {
            const {date_time, amount, account_id, category_id} = data.body;

            config.dbPool.query('SELECT id FROM users WHERE email=$1 AND password=$2;', 
            [decoded.email, decoded.password], (fail, results) => {
                if(results.rowCount > 0) {
                    config.dbPool.query('CALL new_income($1, $2, $3, $4, $5);', 
                        [results.rows[0].id, date_time, amount, account_id, category_id], (fail, ok) => {

                        if (fail) {
                            error(fail.detail);
                            return;
                        }

                        config.dbPool.query('select get_last_operation_id($1);', 
                            [results.rows[0].id], (fails, results) => {
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
    income,
}