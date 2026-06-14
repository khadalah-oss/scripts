const http = require('http');
const port = process.env.PORT || 3000;

const server = http.createServer((req, res) => {
    // Health check endpoint
    if (req.url === '/health') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ status: 'ok', service: 'node-app' }));
        return;
    }

    // Main API response
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({
        message: 'Welcome to Node.js API',
        timestamp: new Date().toISOString(),
        path: req.url,
        method: req.method
    }));
});

server.listen(port, () => {
    console.log(`Node.js server running on port ${port}`);
});
