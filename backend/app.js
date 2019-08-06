const express= require('express');
const bodyParser= require('body-parser')
const app=express();
const dotenv=require('dotenv').config();

//please secure this
let url = "mongodb://master:ceM7kFQCWkdLZcUEXkDaKhkg@ds016108.mlab.com:16108/test-irm";
const port = process.env.PORT || 5000;

var myDB;//global var for the DB, not so clean

let mongodb = require ('mongodb').MongoClient;
app.use(bodyParser.urlencoded({extended:true}));
app.use(bodyParser.json());

mongodb.connect(url, { useNewUrlParser: true },function(err,db,){
    if (err) throw err;
    myDB=db.db("test-irm");
    app.listen(port, function(){
        console.log ('listening to '+ port)
    });
})

app.get('/', (req, res) => res.send('Hello World!'));

app.get('/getuser',(req,res) => {
    let uid = req.query.uid;
    let queryResult=[];
    myDB.collection('team')
    .find({"uid":uid})
    .toArray(function(err,result){
        if (err) {
            res.status(418);
            throw err
        };
        queryResult=JSON.stringify(result);
        console.log(queryResult);
        res.status(200);
        return res.send(queryResult);
    })
});
app.post('/createuser', (req,res)=> {
    //needs sanitization 
    myDB.collection('team').insertOne(req.body,(err,result)=>{
        if (err) {
            res.status(418) 
            return res.send(err)};
        console.log('saved user to database');
        return res.status(200)

    })
});

app.get('/getallusers',(req,res)=>{
    let queryResult=[];
    myDB.collection('team').find( {} ).toArray(function(err,result){
        if (err) {
            res.status(418);
            throw err
        };
        queryResult=JSON.stringify(result);
        console.log(queryResult);
        res.status(200);
        return res.send(queryResult);
    });
});

app.post('/updateuser',(req,res)=>res.send('update user details in MongoDB'));
app.delete('/userdelete',(req,res)=>res.send('delete user in MongoDB'));

app.get('/getevent',(req,res) => res.send('Get event details from mongoDB'));
app.post('/createevent', (req,res)=> {
    myDB.collection('calendar').insertOne(req.body,(err,result)=>{
        if (err) {
            res.status(418) 
            return res.send(err)};
        console.log('saved event to database');
        return res.status(200)
    
    })
});
app.post('/updateevent',(req,res)=>res.send('update event details in MongoDB'));
app.delete('/eventdelete',(req,res)=>{ 
});




