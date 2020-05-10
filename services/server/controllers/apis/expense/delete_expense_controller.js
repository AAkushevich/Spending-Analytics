const
    express = require('express'),
    deleteExpenseService = require('../../../services/new_expense/delete_expense');

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

    deleteExpenseService.deleteExpense(request, error, success);
});

module.exports = router;