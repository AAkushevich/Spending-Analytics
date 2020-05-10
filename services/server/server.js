const
    express = require('express'),
    bodyParser = require('body-parser');

module.exports = function() {
    
    let server = express(),
        create,
        start;

    create = function(config) {
        let routes = require('./routes');

        server.set('env', config.env);
        server.set('port', config.port);
        server.set('hostname', config.hostname);
        server.use(bodyParser.json());

        routes.init(server);
    };

    start = function() {
        let hostname = server.get('hostname'),
            port = server.get('port');

        server.listen(port, function () {
            console.log('Express server listening on - http://' + hostname + ':' + port);
        });
    };

    return {
        create: create,
        start: start
    };
};