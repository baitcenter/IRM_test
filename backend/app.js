const express = require('express');
const bodyParser = require('body-parser')
const app = express();
const dotenv = require('dotenv').config();

//please secure this
let url = process.env.URL;
const port = process.env.PORT || 80;

var myDB;//global var for the DB, not so clean

let mongodb = require('mongodb').MongoClient;
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

mongodb.connect(url, { useNewUrlParser: true }, function (err, db, ) {
    if (err) throw err;
    myDB = db.db("test-irm");
    app.listen(port, function () {
        console.log('listening to ' + port)
    });
})

app.get('/', (req, res) => res.send('Hello World!'));

app.get('/getuser', (req, res) => {
    let uid = req.query.uid;
    let queryResult = [];
    myDB.collection('team')
        .find({ "uid": uid })
        .toArray(function (err, result) {
            if (err) {
                res.status(418);
                throw err
            };
            queryResult = JSON.stringify(result);
            console.log(queryResult);
            res.status(200);
            return res.send(queryResult);
        })
});
app.post('/createuser', (req, res) => {
    //needs sanitization 
    myDB.collection('team').insertOne(req.body, (err, result) => {
        if (err) {
            res.status(418)
            return res.send(err)
        };
        console.log('saved user to database');
        res.status(200)
        res.send("user created");
        return;

    })
});

app.get('/getallusers', (req, res) => {
    let queryResult = [];
    myDB.collection('team').find({}).toArray(function (err, result) {
        if (err) {
            res.status(418);
            throw err
        };
        queryResult = JSON.stringify(result);
        console.log(queryResult);
        res.status(200);
        return res.send(queryResult);
    });
});

//using post as long as no middleware
app.post('/getevents', (req, res) => {

    let reqBody = req.body;
    console.log(req.body);
    console.log(typeof req.body);
    let userName = req.body.userName;
    console.log('username', userName);
    let queryResult = [];
    myDB.collection('calendar').find({ "$or": [{ "owner": req.body }, { "guests.name":userName}] })
        .toArray(function (err, result) {
            if (err) {
                res.status(418);
                throw err
            };
            queryResult = JSON.stringify(result);
            console.log('db event query: ',queryResult);
            res.status(200);
            return res.send(queryResult);
        });
});
app.post('/createevent', (req, res) => {
    myDB.collection('calendar').insertOne(req.body, (err, result) => {
        if (err) {
            res.status(418)
            return res.send(err)
        };
        console.log('saved event to database');
        res.status(200);
        res.send("event created");
        return;
    })
});
app.post('/updateevent', (req, res) => {
    let reqBody=req.body;
    console.log (reqBody);
    try {
       result =  myDB.collection('calendar').replaceOne({$and:[{"event.title":reqBody.event.title},{"owner.userName":reqBody.owner.userName}]},reqBody);
        res.status(200);
        console.log('event updated');
        res.send('event updated');
    }
        catch(e){
            console.log(e);
            res.status(418);
            res.send(e);
        }
    });

//TO DO: send different msg if event already deleted
app.delete('/deleteevent', (req, res) => {
    try {
        let erase = myDB.collection('calendar').deleteOne({ "event.eventId": req.query.eventId },{"owner.userName":req.query.user});
        res.status(200);
        res.send('event deleted');
    } catch (e) {
        console.log(e);
        res.status(418);
        return res.send(e);
    }

    

});




