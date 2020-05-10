var config = require('../../../config/init');
var jwt = require('jsonwebtoken');

function removeScore(data, error, success) {
    jwt.verify(data.headers.token, config.tokenKey.key, function(err, decoded) {
        const id = data.query.id;
        if(decoded) {
            config.dbPool.query('SELECT id FROM users WHERE email=$1 AND password=$2;', 
            [decoded.email, decoded.password], (fail, results) => {
                if(results.rowCount > 0) {
                    config.dbPool.query('DELETE FROM accounts WHERE id=$1;', 
                    [id], (fail, results) => {
                        if(results.rowCount > 0) {
                            success();
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
    removeScore,
}