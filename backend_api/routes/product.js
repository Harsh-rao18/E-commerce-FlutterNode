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
// new route for retrieving products by subcategory
productRouter.get(
  "/api/products-by-subcategory/:subCategory",
  async (req, res) => {
    try {
      const { subCategory } = req.params;
      const products = await Product.find({ subCategory: subCategory });
      if (!products || products.length == 0) {
        return res.status(404).json({ msg: "Product not found" });
      } else {
        return res.status(200).json({ products });
      }
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
);

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

// Route for searching products by name or description
productRouter.get("/api/search-products", async (req, res) => {
  try {
    const { query } = req.query;
    // Validate the query parameter
    // if missing a return 404 status with an error message
    if (!query) {
      return res.status(400).json({ msg: "Query parameter required" });
    }

    // Search the product collection for documents where either 'productName' or 'description'
    // contains the specified query

    const products = await Product.find({
      $or: [
        // Regex will match any productName containing the query String
        { productName: { $regex: query, $options: "i" } },
        { description: { $regex: query, $options: "i" } },
      ],
    });

    if (!products || products.length == 0) {
      return res.status(404).json({ msg: "Product not found" });
    } else {
      return res.status(200).json(products);
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Route to  edit an existing product
productRouter.put(
  "/api/edit-product/:productId",
  auth,
  vendorAuth,
  async (req, res) => {
    try {
      const { productId } = req.params;

      const product = await Product.findById(productId);

      if (!product) {
        return res.status(404).json({ msg: "Product Not Found" });
      }

      if (product.vendorId.toString() !== req.user.id) {
        return res
          .status(403)
          .json({ msg: "Unauthorized to edit the product" });
      }

      const {vendorId,...updateData} = req.body; // exclude the vendorId

      const updateProduct = await Product.findByIdAndUpdate(productId,{$set:updateData},{new:true});

      return res.status(200).json(updateProduct);
    } catch (error) {
      return res.status(500).json({ error: error.message });
    }
  }
);

module.exports = productRouter;
