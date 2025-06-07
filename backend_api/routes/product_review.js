const express = require('express');
const ProductReview = require('../models/product_review');

const reviewRouter = express.Router();

reviewRouter.post('/api/product-review',async (req,res) => {
    try {
       const {buyerId,email,fullName,productId,rating,review} = req.body;
       const reviews = new ProductReview({buyerId,email,fullName,productId,rating,review});
       await reviews.save();
       res.status(201).send(reviews)  ;
    } catch (error) {
        res.status(500).json({error:error.message});
    }     
});

reviewRouter.get('/api/product-review',async (req,res) => {
    try {
        const reviews = await ProductReview.find();
        res.status(200).json(reviews);
    } catch (error) {
        res.status(500).json({error:error.message}); 
    }
});

module.exports = reviewRouter;