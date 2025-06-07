const express = require("express");
const Product = require('../models/product');

const productRouter = express.Router();

productRouter.post('/api/product',async (req,res) => {
    try {
        const {productName,productPrice,quantity,description,category,subCategory,images} =req.body;
        const product = new Product({productName,productPrice,quantity,description,category,subCategory,images});
        await product.save();
        return res.status(201).send(product);
    } catch (error) {
        res.status(500).json({error:error.message});
    }
});

productRouter.get('/api/popular-products',async (req,res) => {
    try {
        const product = await Product.find({popular:true});
        if (!product || product.length == 0) {
            return res.status(404).json({msg:"product not found"});
        } else {
            return res.status(200).json({product});
        }
    } catch (error) {
        res.status(500).json({error:error.message}) 
    }
});
productRouter.get('/api/recommended-products',async (req,res) => {
    try {
        const product = await Product.find({recommend:true});
        if (!product || product.length == 0) {
            return res.status(404).json({msg:"product not found"});
        } else {
            return res.status(200).json({product});
        }
    } catch (error) {
        res.status(500).json({error:error.message}) 
    }
});

module.exports = productRouter;