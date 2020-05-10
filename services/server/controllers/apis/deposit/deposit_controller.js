const
    express = require('express'),
    depositService = require('../../../services/deposit/new_deposit');

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

    depositService.deposit(request, error, success);
});

module.exports = router;