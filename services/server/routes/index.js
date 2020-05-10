const
    apiRoute = require('./apis/index');

function init(server) {
    server.get('*', function (req, res, next) {
        console.log('Request was made to: ' + req.originalUrl);
        return next();
    });

    server.get('/', function (req, res) {
        res.redirect('/home');
    });

    server.use('/api', apiRoute);
}

module.exports = {
    init: init
};