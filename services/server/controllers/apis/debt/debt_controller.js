const
    express = require('express'),
    debtService = require('../../../services/debt/new_debt');

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

    debtService.debt(request, error, success);
});

module.exports = router;