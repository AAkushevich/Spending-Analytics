const
    express = require('express'),
    creditService = require('../../../services/credit/new_credit');

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
            status: "success"
        });
    }

    creditService.credit(request, error, success);
});

module.exports = router;