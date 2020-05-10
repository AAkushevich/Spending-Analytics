const
    express = require('express'),
    deleteDepositService = require('../../../services/deposit/delete_deposit');

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

    deleteDepositService.deleteDeposit(request, error, success);
});

module.exports = router;