var config = require('../../../config/init');
var jwt = require('jsonwebtoken');

async function fetchData(data, error, success) {

    jwt.verify(data.headers.token, config.tokenKey.key,async function(err, decoded) {
        if(decoded) {
            const {user_id} = data.query;
            
            config.dbPool.query('SELECT id FROM users WHERE email=$1 AND password=$2;', 
            [decoded.email, decoded.password], async (fail, results) => {
                if(results.rowCount > 0) {

                    let incomeQuery = await config.dbPool.query('SELECT * FROM get_income($1);', [user_id]).catch((failMsg) => {
                        error(failMsg);
                    });
        
                    let expenseQuery = await config.dbPool.query('SELECT * FROM get_expenses($1);', [user_id]).catch((failMsg) => {
                        error(failMsg);
                    });

                    let transferQuery = await config.dbPool.query('SELECT * FROM get_transfer($1);', [user_id]).catch((failMsg) => {
                        error(failMsg);
                    });

                    let debtsQuery = await config.dbPool.query('SELECT * FROM get_debts($1);', [user_id]).catch((failMsg) => {
                        error(failMsg);
                    });

                    let creditsQuery = await config.dbPool.query('SELECT * FROM get_credits($1);', [user_id]).catch((failMsg) => {
                        error(failMsg);
                    });

                    let depositQuery = await config.dbPool.query('SELECT * FROM get_deposit($1);', [user_id]).catch((failMsg) => {
                        error(failMsg);
                    });

                    success(incomeQuery.rows, expenseQuery.rows, transferQuery.rows, 
                        debtsQuery.rows, creditsQuery.rows, depositQuery.rows);

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
    fetchData,
}