var config = require('../../../config/init');
var jwt = require('jsonwebtoken');

function getCategories(data, error, success) {
    jwt.verify(data.headers.token, config.tokenKey.key, function(err, decoded) {
        if(decoded) {
            config.dbPool.query('SELECT id FROM users WHERE email=$1 AND password=$2;', 
            [decoded.email, decoded.password], (fail, results) => {
                if(results.rowCount > 0) {
                    config.dbPool.query('SELECT * FROM categories WHERE user_id IS NULL;', 
                    [], (fail, results) => {
                        console.log(results);
                        if (fail) {
                            error(fail.detail);
                            return;
                        }
                        success(results.rows);
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
    getCategories,
}


