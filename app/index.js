const express = require('express');
const client = require('prom-client');

const app = express();
const register = new client.Registry();
client.collectDefaultMetrics({ register });

app.get('/health', (req, res) => {
  res.status(200).send('OK');
});

app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});

app.get('/', (req, res) => {
  res.send('SRE App Running');
});

const server = app.listen(3000, () => {
  console.log('App running on port 3000');
});

// Graceful shutdown (IMPORTANT FOR SRE)
process.on('SIGTERM', () => {
  server.close(() => {
    process.exit(0);
  });
});

