var jwt = require('jsonwebtoken');
var config = require('./../../config/init');

    function decodeToken(token) {
        return jwt.decode(token);
    }

    function getToken(email, password) {
        var token = jwt.sign({ 
            exp: Date.now() + 24 * 14 * 60 * 60,
            email : email,
            password : password, 
            date : new Date()
        }, config.tokenKey.key);

        return token;
    }

module.exports = {
    getToken: getToken,
    decodeToken: decodeToken
};
