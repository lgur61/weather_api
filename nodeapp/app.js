const express = require("express");
const axios = require("axios");
const redis = require("redis");

const redisClient = redis.createClient({
  socket: {
    host: process.env.REDIS_HOSTNAME,
    port: parseInt(process.env.REDIS_PORT),
  },
});

(async () => {
  await redisClient.connect();
})();

const app = express();

redisClient.on("ready", () => {
  console.log("Connected!");
});

redisClient.on("error", (err) => {
  console.error(err);
});

const cache = (req, res, next) => {
  const { location } = req.params;

  redisClient
    .get(location)
    .then((value) => {
      if (value !== null) {
        let val = JSON.parse(value);
        val.source = "Redis Cache";
        return res.json(val);
      } else {
        return next();
      }
    })
    .catch((error) => {
      next(error);
    });
};

app.use((err, req, res, next) => {
  err.statusCode = err.statusCode || 500;
  err.status = err.status || "error";
  res.status(err.statusCode).json({
    status: err.status,
    message: err.message,
  });
});

app.get("/current/:location", cache, async function (req, res) {
  const API_KEY = "aa1b2c2361b74ac8c919ab868e0b7f1b";
  const { location } = req.params;
  try {
    const coordinates = await axios.get(
      `http://api.openweathermap.org/geo/1.0/direct?q=${location}&limit=3&appid=${API_KEY}`
    );

    const weather = await axios.get(
      `https://api.openweathermap.org/data/2.5/weather?lat=${coordinates.data[0].lat}&lon=${coordinates.data[0].lon}&appid=${API_KEY}`
    );

    redisClient.set(location, JSON.stringify(weather.data));
    weather.data.source = "Weather API";
    return res.json(weather.data);
  } catch (error) {
    throw error;
  }
});

app.get("/health", async function (req, res) {
  res.status(200).send("Service is up and running !");
});

app.get("/env", async function (req, res) {
  const host = process.env.REDIS_HOSTNAME;
  const port = process.env.REDIS_PORT;

  res.status(200).json({ host: host, port: port });
});

app.listen(8080, () => console.log(`Running on 8080`));
