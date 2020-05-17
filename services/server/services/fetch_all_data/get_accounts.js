var config = require('../../../config/init');
var jwt = require('jsonwebtoken');

async function getAccounts(data, error, success) {

    jwt.verify(data.headers.token, config.tokenKey.key,async function(err, decoded) {
        if(decoded) {
            config.dbPool.query('SELECT id FROM users WHERE email=$1 AND password=$2;', 
            [decoded.email, decoded.password], async (fail, results) => {
                if(results.rowCount > 0) {
                    let user_id = results.rows[0].id;
                    let accountsQuery = await config.dbPool.query('SELECT * FROM get_accounts($1);', [user_id]).catch((failMsg) => {
                        error(failMsg);
                    });

                    success(accountsQuery.rows)

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
    getAccounts,
}