const
    express = require('express'),
    deleteIncomeService = require('../../../services/income/delete_income');

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

    deleteIncomeService.deleteIncome(request, error, success);
});

module.exports = router;