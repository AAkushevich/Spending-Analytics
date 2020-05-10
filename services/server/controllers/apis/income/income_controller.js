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

    function success() {
        response.status(200).send({
            status: "success"
        });
    }

    incomeService.income(request, error, success);
});

module.exports = router;