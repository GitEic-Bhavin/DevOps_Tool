// Enable Datadog APM Tracing
require('dd-trace').init();

const express = require('express')
const bodyParser = require('body-parser')
const redis = require('redis')
const app = express();
const PORT = process.env.PORT || 3000;

// Connect to Redis
const redisClient = redis.createClient({
    url: `redis://${process.env.REDIS_HOST}:${process.env.REDIS_PORT}`
});
redisClient.on('error', (err) => console.error('Redis Client Error', err));

// app.use(bodyParser.json());

// app.get('/', async (req, res) => {
//     const visits = await redisClient.get('visits');
//     if (visits) {
//         await redisClient.set('visits', parseInt(visits) + 1);
//     } else {
//         await redisClient.set('visits', 1);
//     }
//     res.send(`Hello, World! You are visitor number ${visits || 1}`);
//     });

//     app.listen(PORT, () => {
//         console.log(`Server is running on port ${PORT}`);
//     });

// Important: Connect the client
(async () => {
    await redisClient.connect();
})();

app.use(bodyParser.json());

app.get('/', async (req, res) => {
    let visits = await redisClient.get('visits');
    if (visits) {
        visits = parseInt(visits) + 1;
        await redisClient.set('visits', visits);
    } else {
        visits = 1;
        await redisClient.set('visits', visits);
    }
    res.send(`Hello, World! You are visitor number ${visits}`);
});

app.listen(PORT, () => {
    console.log(`Server is running  on  port ${PORT}`);
});