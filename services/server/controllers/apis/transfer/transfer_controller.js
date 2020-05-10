const
    express = require('express'),
    transferService = require('../../../services/transfer/transfer');

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

    transferService.transfer(request, error, success);
});

module.exports = router;