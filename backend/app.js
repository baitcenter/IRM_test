const express= require('express');
const bodyParser= require('body-parser')
const app=express();
const dotenv=require('dotenv').config();

//please secure this
let url = "mongodb://localhost:27017/dorothycares";
const port = process.env.PORT || 5000;

var myDB;//global var for the DB, not so clean

let mongodb = require ('mongodb').MongoClient;
app.use(bodyParser.urlencoded({extended:true}));
app.use(bodyParser.json());

app.get('/', (req, res) => res.send('Hello World!'));

app.get('/getuser',(req,res) => res.send('Get user details from mongoDB'));
app.post('/createuser', (req,res)=> res.send('Create new user in MongoDB'));
app.post('/updateuser',(req,res)=>res.send('update user details in MongoDB'));
app.delete('/userdelete',(req,res)=>res.send('delete user in MongoDB'));

app.get('/getevent',(req,res) => res.send('Get event details from mongoDB'));
app.post('/createevent', (req,res)=> res.send('Create new event in MongoDB'));
app.post('/updateevent',(req,res)=>res.send('update event details in MongoDB'));
app.delete('/eventdelete',(req,res)=>res.send('delete event in MongoDB'));


app.listen(port, () => console.log(`Example app listening on port ${port}!`));