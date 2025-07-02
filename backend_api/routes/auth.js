const express = require('express');
const User = require('../models/user');
const bcrypt = require('bcryptjs');
const authRouter = express.Router();
const jwt = require('jsonwebtoken');

// creating api for signup
authRouter.post('/api/signup',async (req,res)=>{
    try {
        // object destructring(extracting values from object)
        const {fullName,email,password} =  req.body;
        // finding the existing email
        const existintEmail = await User.findOne({email});

        // if exist
        if (existintEmail) {
            return res.status(400).json({msg:"user with same email already exist"});
        } else {
            // generate a salt with cost factor of 10
            const salt = await bcrypt.genSalt(10);
            // hash the password using the generated salt
            const hashedPassword = await bcrypt.hash(password,salt);


            // if not then we will create new user
          let user = new User({fullName,email,password : hashedPassword});
          // saving the user
          user = await user.save();
          res.json({user});
        }
    } catch (error) { 
        // if some error occurred 
        res.status(500).json({error:error.message});  
    }
});

// creating api for signin
authRouter.post('/api/signin',async(req,res)=>{
    try {
        const {email,password} = req.body;
        const existingEmail = await User.findOne({email});
        if (!existingEmail) {
            return res.status(400).json({msg:"User not found with this email"});
        } else {
         const isMatch = await bcrypt.compare(password,existingEmail.password);
         if (!isMatch) {
            return res.status(400).json({msg:"Invalid User Credentails"});
         } else {
            const token = jwt.sign({id:existingEmail._id}, "passwordKey");
            // exclude the password so we dont have to return it to the user 
            const {password, ...userWithoutPassword} = existingEmail._doc;

            // send the response
            res.json({token, user:userWithoutPassword});
         }
        }
    } catch (error) {
        // if some error occurred 
        res.status(500).json({error:error.message}); 
    }
});

module.exports = authRouter;