const express = require('express');
const bodyParser = require('body-parser');
const path = require('path');

const api = require('./server/routes/api');

const port = 3001;

const app = express();

app.use(express.static(path.join(__dirname, 'dist')));

app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());

app.use('/api', api);

app.use(express.static(path.join(__dirname, 'dist/lab4/browser')));
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'dist/lab4/browser/index.html'));
});

app.listen(port, function(){
    console.log("Server running on localhost:" + port);
});
