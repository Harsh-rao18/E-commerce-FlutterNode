const express = require('express');
const Vendor = require("../models/vendor");

const vendorRouter = express.Router();

const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

// create a signup api for vendor
vendorRouter.post("/api/vendor/signup", async (req,res)=>{
    try {
        const {fullName,email,password} = req.body;

        const existingEmail = await Vendor.findOne({email});

    if (existingEmail) {
       return res.status(400).json({msg:"vendor with same email already exist"})
    } else {
        const salt = await bcrypt.genSalt(10);

        const hashedPassword = await bcrypt.hash(password,salt);

        let vendor = new Vendor({fullName,email,password:hashedPassword});
        vendor = await vendor.save();
        res.json({vendor});
    }
    } catch (error) {
        res.status(500).json({error:error.message});
    }
});

// create a signin api for vendor
vendorRouter.post('/api/vendor/signin',async(req,res)=>{
    try {
        const {email,password} = req.body;
        const existingEmail = await Vendor.findOne({email});
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

module.exports = vendorRouter;