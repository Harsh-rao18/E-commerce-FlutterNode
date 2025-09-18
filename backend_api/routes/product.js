const express = require("express");
const Product = require("../models/product");

const productRouter = express.Router();

const { auth, vendorAuth } = require("../middleware/auth");

productRouter.post("/api/product", auth, vendorAuth, async (req, res) => {
  try {
    const {
      productName,
      productPrice,
      quantity,
      description,
      category,
      subCategory,
      images,
      vendorId,
      fullName,
    } = req.body;
    const product = new Product({
      productName,
      productPrice,
      quantity,
      description,
      category,
      subCategory,
      images,
      vendorId,
      fullName,
    });
    await product.save();
    return res.status(201).send(product);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

productRouter.get("/api/popular-products", async (req, res) => {
  try {
    const product = await Product.find({ popular: true });
    if (!product || product.length == 0) {
      return res.status(404).json({ msg: "product not found" });
    } else {
      return res.status(200).json({ product });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});
productRouter.get("/api/recommended-products", async (req, res) => {
  try {
    const product = await Product.find({ recommend: true });
    if (!product || product.length == 0) {
      return res.status(404).json({ msg: "product not found" });
    } else {
      return res.status(200).json(product);
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// new route for retrieving products by category
productRouter.get("/api/products-by-category/:category", async (req, res) => {
  try {
    const { category } = req.params;
    const products = await Product.find({ category, popular: true });
    if (!products || products.length == 0) {
      return res.status(404).json({ msg: "Product not found" });
    } else {
      return res.status(200).json({ products });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// new route for retrieving related product by subcategory
productRouter.get(
  "/api/related-products-by-subcategory/:productId",
  async (req, res) => {
    try {
      const { productId } = req.params;
      // find the product based on product Id
      const product = await Product.findById({ productId });

      if (!product) {
        return res.status(404).json({ msg: "Product not found" });
      } else {
        // find the related product of same subcategory based on product Id and exclude the same product
        const relatedProducts = await Product.find({
          subCategory: product.subCategory,
          _id: { $ne: productId },
        });

        if (!relatedProducts || relatedProducts.length == 0) {
          return res.status(404).json({ msg: "Product not found" });
        } else {
          return res.status(200).json(relatedProducts);
        }
      }
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
);

// new route for retrieving the top 10 highest rated products
productRouter.get("/api/top-rated-products", async (req, res) => {
  try {
    // fetch all products and sort them by averageRating in desending order
    // sort product by averageRating with -1 indicating desending
    const product = await Product.find({})
      .sort({ averageRating: -1 })
      .limit(10);
    if (!product || product.length == 0) {
      return res.status(404).json({ msg: "No Top Rated Product found" });
    } else {
      return res.status(200).json(product);
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = productRouter;
