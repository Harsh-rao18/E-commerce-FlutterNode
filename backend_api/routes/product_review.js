const express = require('express');
const ProductReview = require('../models/product_review');
const Product = require('../models/product');

const reviewRouter = express.Router();

reviewRouter.post('/api/product-review',async (req,res) => {
    try {
       const {buyerId,email,fullName,productId,rating,review} = req.body;
       // check if the user already reviewed the product
       const existingReview = await ProductReview.findOne({buyerId,productId});
       if (existingReview) {
        return res.status(400).json({msg:"you have already reviewed this product"});
       }
       const reviews = new ProductReview({buyerId,email,fullName,productId,rating,review});
       await reviews.save();
       // find the product associated with the review using productId
       const product = await Product.findById(productId);
       if (!product) {
        res.status(404).json({msg:"Product Not Found"});
       }

       // Update the totalRatings incrementing it by 1
       product.totalRatings += 1;
       product.averageRating = ((product.averageRating * (product.totalRatings-1))+rating)/product.totalRatings;
       // save the updated product
       await product.save();
       res.status(201).send(reviews);
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