
const
    express = require('express'),
    loginService = require('../../../services/login/login');

let router = express.Router();

router.post('/', (request, response) => {

    function error(message) {
        response.status(400).send({
            status: "error",
            msg: message
        });
    }

    function success(jwtToken) {
        response.status(200).send({
            status: "success",
            token: jwtToken
        });
    }

    loginService.login(request.body, error, success);

});

module.exports = router;