//  import the express and mongoose module
const express = require('express');
const mongoose = require('mongoose');

// importing the routers
const authRouter = require('./routes/auth')
const bannerRouter = require('./routes/banner')
const categoryRouter = require('./routes/category')
const subCategoryRouter = require('./routes/sub_category')
const productRouter = require('./routes/product')
const reviewRouter = require('./routes/product_review')
const cors = require('cors')

// Define the port number that server will listen on
const PORT = 3000;

// create an instance of an express application
//beacuse it give us the starting point
const app = express();

// MongoDB string 
const DB = 'mongodb+srv://harshrao64644:harshrao@cluster0.tnms4fy.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0'

// middleware - to register routes or to mount routes
app.use(express.json());
app.use(cors()); // enable cors for all routes and origin
app.use(authRouter);
app.use(bannerRouter);
app.use(categoryRouter);
app.use(subCategoryRouter);
app.use(productRouter);
app.use(reviewRouter);


// connectig to database
mongoose.connect(DB).then(()=> {
    console.log('MongoDB Connected');  
});

// starting the server and listen on the specified port
app.listen(PORT, "0.0.0.0", function() {
    // LOG the Number
    console.log(`server is running on port ${PORT}`);
})