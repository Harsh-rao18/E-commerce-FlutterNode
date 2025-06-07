const express = require('express');
const SubCategory = require('../models/sub_category');

const subCategoryRouter = express.Router();

subCategoryRouter.post('/api/subcategories', async (req, res) => {
    try {
        const { categoryId, categoryName, image, subCategoryName } = req.body;
        const subCategory = new SubCategory({ categoryId, categoryName, image, subCategoryName });
        await subCategory.save();
        res.status(201).send(subCategory);
    } catch (error) {
        res.status(500).json({error:error.message})
    }
});

// Get subcategories by category name
subCategoryRouter.get('/api/category/:categoryName/subcategories',async (req,res) => {
    try {
        /// extract the categoryName from the request url using Destructuring
        const {categoryName} = req.params;
        const subCategory = await SubCategory.find({categoryName});

        // check if any subcategories were found
        if (!subCategory || subCategory.length == 0) {
            // if not then
            return res.status(404).json({msg:"subcategories not found"});
        } else {
            // if found then
            return res.status(200).json(subCategory);
        }
    } catch (error) {
        res.status(500).json({error:error.message}) 
    }
})

module.exports = subCategoryRouter;