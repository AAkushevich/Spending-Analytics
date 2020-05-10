const
    express = require('express'),
    deleteTransferService = require('../../../services/transfer/delete_transfer');

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

    deleteTransferService.deleteTransfer(request, error, success);
});

module.exports = router;