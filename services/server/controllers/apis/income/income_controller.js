const
    express = require('express'),
    incomeService = require('../../../services/income/income');

let router = express.Router();

router.post('/', (request, response) => {

    function error(message) {
        response.status(400).send({
            status: "error",
            msg: message
        });
    }

    function success(operation_id) {
        response.status(200).send({
            status: "success",
            "operation_id" : operation_id
        });
    }

    incomeService.income(request, error, success);
});

module.exports = router;