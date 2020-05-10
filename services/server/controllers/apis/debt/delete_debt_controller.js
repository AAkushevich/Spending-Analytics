const
    express = require('express'),
    deleteDebtService = require('../../../services/debt/delete_debt');

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

    deleteDebtService.deleteDebt(request, error, success);
});

module.exports = router;