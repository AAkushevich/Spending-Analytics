const
    express = require('express'),
    fetchDataService = require('../../../services/fetch_all_data/fetch_data');

let router = express.Router();

router.get('/', (request, response) => {

    function error(message) {
        response.status(400).send({
            status: "error",
            msg: message
        });
    }

    function success(income, expense, transfers, debts, credits, deposits) {
        response.status(200).send({
            status: "success",
            "income" : income,
            "expense" : expense,
            "transfers" : transfers,
            "debts" : debts,
            "credits" : credits,
            "deposits" : deposits
        });
    }

    fetchDataService.fetchData(request, error, success);
});

module.exports = router;