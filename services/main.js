const
    server = require('./server/server')(),
    config = require('./config/local');

server.create(config);
server.start();