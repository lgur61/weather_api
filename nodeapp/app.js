const express = require("express")
const axios = require("axios")
const redis = require("redis");

const redisClient = redis.createClient({
  host: 'node-app-redis.atppn3.ng.0001.use1.cache.amazonaws.com',
  port: 6379, // default port 
});

const app = express()



const cache = (req, res, next) => {
  const { location } = req.params;

  redisClient.get(location, (error, result) => {
    if (error) throw error;
    if (result !== null) {
      let res = JSON.parse(result)
      res.source = "Redis Cache";
      return res.json(JSON.stringify(res));
    } else {
      return next();
    }
  });
};


app.get("/current/:location", cache, async function(req, res) {
    const API_KEY = "aa1b2c2361b74ac8c919ab868e0b7f1b"
  try {   

    const coordinates = await axios.get(
      `http://api.openweathermap.org/geo/1.0/direct?q=${req.params.location}&limit=3&appid=${API_KEY}`    
    ); 
    
    const weather = await axios.get(
      `https://api.openweathermap.org/data/2.5/weather?lat=${coordinates.data[0].lat}&lon=${coordinates.data[0].lon}&appid=${API_KEY}`    
    );    
   
    redisClient.set(req.params.location, JSON.stringify(weather.data));
    weather.data.source = "Weather API"
    return res.json(weather.data);

      
  } catch (error) {
    res.status(500).send({error: error.message});
  }
});

app.get("/health", async function(req, res) {
   
    res.status(200).send("Service is up and running !");
  
});




app.listen(8080, () => console.log(`Running on 8080`))
