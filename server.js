/**
 * @description API intermediaria para consumir Cognitive Services 
 *              Se encuentra securizada con un Bearer Token 
 *              Dispone de un sistema de caché para economizar las llamadas
 * @author Paco FELC 2019
 */
const express = require('express');
const http = require('http');
const bodyParser = require('body-parser');
const router = require('./src/routes/router');


const app = express();
app.use(bodyParser.json());

require('dotenv').config();


app.get('/', (req, res) => {
    res.status(200).send("Welcome to API REST");
})

http.createServer(app).listen(process.env.PORT, () => {
    console.log('Server is running on port ' + process.env.PORT);
});

/**
 * Services Api
 */
const pathApi = "/api/v1";

app.use(`${ pathApi }`, router);
/**
 * End Services Api
 */

module.exports = app;
