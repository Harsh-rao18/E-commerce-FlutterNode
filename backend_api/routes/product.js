const express = require("express");
const Product = require('../models/product');

const productRouter = express.Router();

const {auth,vendorAuth} = require('../middleware/auth');


productRouter.post('/api/product',auth,vendorAuth,async (req,res) => {
    try {
        const {productName,productPrice,quantity,description,category,subCategory,images,vendorId,fullName} =req.body;
        const product = new Product({productName,productPrice,quantity,description,category,subCategory,images,vendorId,fullName,});
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
            return res.status(200).json(product);
        }
    } catch (error) {
        res.status(500).json({error:error.message}) 
    }
});

// new route for retrieving products by category
productRouter.get('/api/products-by-category/:category',async (req,res) => {
    try {
        const {category} = req.params;
        const products =  await Product.find({category,popular:true});
        if (!products || products.length ==  0) {
            return res.status(404).json({msg:"Product no found"});
        } else {
            return res.status(200).json({products});
        }

    } catch (error) {
        res.status(500).json({error:e.message});
    }
});

module.exports = productRouter;