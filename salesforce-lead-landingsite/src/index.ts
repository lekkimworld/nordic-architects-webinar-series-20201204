import express from "express";
import {config as dotenv_config} from "dotenv";
import {json as bpjson} from "body-parser";
import createRedisClient from "./redis";
import configureRedisSession from "./redis-session";
import configureStatic from "./static";
import configureRoutes from "./configure-routes";
import configureHandlebars from "./handlebars";
import configureProductCache from "./product-cache";

// read .env
dotenv_config();

// create app
const app = express();
app.use(bpjson());

// configure handlebats
configureHandlebars(app);

// configure static files
configureStatic(app);

// configure session
const redisClient = createRedisClient();
configureRedisSession(app, redisClient);

// create routes
configureRoutes(app);

// load cache of product families
configureProductCache(redisClient);

// listen
app.listen(process.env.PORT || 8080);
console.log(`Started listening on port ${process.env.PORT || 8080}`);''