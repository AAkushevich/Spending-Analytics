const
    express = require('express'),
    sigInService = require('../../../services/signUp/sign_up');

let router = express.Router();

router.post('/', (request, response) => {

    function error(message) {
        response.status(400).send({
            status: "error",
            msg: message
        });
    }

    function success() {
        response.status(200).send({
            status: "success",
        });
    }

    sigInService.registerNewUser(request.body, error, success);
});




module.exports = router;