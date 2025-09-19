const express = require("express");
const ProductReview = require("../models/product_review");
const Product = require("../models/product");

const reviewRouter = express.Router();

reviewRouter.post("/api/product-review", async (req, res) => {
  try {
    const { buyerId, email, fullName, productId, rating, review } = req.body;

    // check if the user already reviewed the product
    const existingReview = await ProductReview.findOne({ buyerId, productId });
    if (existingReview) {
      return res
        .status(400)
        .json({ msg: "You have already reviewed this product" });
    }

    // create review
    const newReview = new ProductReview({
      buyerId,
      email,
      fullName,
      productId,
      rating,
      review,
    });
    await newReview.save();

    // find product
    const product = await Product.findById(productId);
    if (!product) {
      return res.status(404).json({ msg: "Product Not Found" });
    }

    // Ensure defaults
    if (!product.totalRatings) product.totalRatings = 0;
    if (!product.averageRating) product.averageRating = 0;

    // update product ratings
    product.totalRatings += 1;
    product.averageRating =
      (product.averageRating * (product.totalRatings - 1) + rating) /
      product.totalRatings;

    await product.save();

    res
      .status(201)
      .json({ msg: "Review added and product updated", review: newReview });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: error.message });
  }
});

reviewRouter.get("/api/product-review", async (req, res) => {
  try {
    const reviews = await ProductReview.find();
    res.status(200).json(reviews);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = reviewRouter;
