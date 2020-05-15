const
    express = require('express'),
    getAccountsService = require('../../../services/fetch_all_data/get_accounts');

let router = express.Router();

router.get('/', (request, response) => {

    function error(message) {
        response.status(400).send({
            status: "error",
            msg: message
        });
    }

    function success(accounts) {
        response.status(200).send({
            status: "success",
            "accounts" : accounts
        });
    }

    getAccountsService.getAccounts(request, error, success);
});

module.exports = router;