// 1 import the express module
const express = require('express');

// 7
const mongoose = require('mongoose');
const authRouter = require('./routes/auth')

//2 Define the port number that server will listen on
const PORT = 3000;

// 3 create an instance of an express application
//beacuse it give us the starting point
const app = express();

// 8 MongoDB string 
const DB = 'mongodb+srv://harshrao64644:harshrao@cluster0.tnms4fy.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0'

// middleware - to register routes or to mount routes
app.use(express.json());
app.use(authRouter);
// 9
mongoose.connect(DB).then(()=> {
    console.log('MongoDB Connected'); 
    
});

// 4 starting the server and listen on the specified port
app.listen(PORT, "0.0.0.0", function() {
    // LOG the Number
    console.log(`server is running on port ${PORT}`);
})