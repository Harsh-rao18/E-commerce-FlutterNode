const express = require('express');
const Category = require('../models/category')

// instance of a router
const categoryRouter = express.Router();

// post api endpoint for category
categoryRouter.post('/api/category', async (req,res) => {
    try {
        const {name,image,banner} = req.body;
        const category = new Category({name,image,banner});
        await category.save();
        return res.status(201).send(category);

    } catch (error) {
        res.status(500).json({error:error.message});
    }
});

// get api endpoint for category
categoryRouter.get('/api/category',async (req,res) => {
    try {
        const category = await Category.find();
        return res.status(200).send(category);
    } catch (error) {
        res.status(500).json({error:error.message});
    }
});

module.exports = categoryRouter;