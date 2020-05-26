const
    express = require('express'),
    categoriesService = require('../../../services/categories/get_categories');

let router = express.Router();

router.get('/', (request, response) => {

    function error(message) {
        response.status(400).send({
            status: "error",
            msg: message
        });
    }

    function success(categories) {
        response.status(200).send({
            status: "success",
            "categories" : categories
        });
    }

    categoriesService.getCategories(request, error, success);
});

module.exports = router;