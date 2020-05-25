const
    express = require('express'),
    newScoreService = require('../../../services/newScore/new_score');

let router = express.Router();

router.post('/', (request, response) => {

    function error(message) {
        response.status(400).send({
            status: "error",
            msg: message
        });
    }

    function success(rowId) {
        response.status(200).send({
            status: "success",
            account_id: rowId
        });
    }

    newScoreService.newScore(request, error, success);
});

module.exports = router;