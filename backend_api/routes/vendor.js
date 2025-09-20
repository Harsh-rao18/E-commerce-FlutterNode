const express = require("express");
const Vendor = require("../models/vendor");
const User = require("../models/user");

const vendorRouter = express.Router();

const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

const { auth } = require("../middleware/auth");


// create a signup api for vendor
vendorRouter.post("/api/v2/vendor/signup", async (req, res) => {
  try {
    const {
      fullName,
      email,
      password,
      storeName,
      storeImage,
      storeDescription,
    } = req.body;

    // check if email already exist users collection
    const existingUserEmail = await User.findOne({ email });

    if (!existingUserEmail) {
      const existingEmail = await Vendor.findOne({ email });

      if (existingEmail) {
        return res
          .status(400)
          .json({ msg: "vendor with same email already exist" });
      } else {
        const salt = await bcrypt.genSalt(10);

        const hashedPassword = await bcrypt.hash(password, salt);

        let vendor = new Vendor({
          fullName,
          email,
          password: hashedPassword,
          storeName,
          storeImage,
          storeDescription,
        });
        vendor = await vendor.save();
        res.json({ vendor });
      }
    } else {
        return res
          .status(400)
          .json({ msg: "user with same email already exist"});
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// create a signin api for vendor
vendorRouter.post("/api/v2/vendor/signin", async (req, res) => {
  try {
    const { email, password } = req.body;
    const existingEmail = await Vendor.findOne({ email });
    if (!existingEmail) {
      return res.status(400).json({ msg: "User not found with this email" });
    } else {
      const isMatch = await bcrypt.compare(password, existingEmail.password);
      if (!isMatch) {
        return res.status(400).json({ msg: "Invalid User Credentails" });
      } else {
        const token = jwt.sign({ id: existingEmail._id }, "passwordKey",{expiresIn: "30m",});
        // exclude the password so we dont have to return it to the user
        const { password, ...userWithoutPassword } = existingEmail._doc;

        // send the response
        res.json({ token,userWithoutPassword });
      }
    }
  } catch (error) {
    // if some error occurred
    res.status(500).json({ error: error.message });
  }
});

// Fetch all vendors(exclude password)
vendorRouter.get("/api/vendors", async (req, res) => {
  try {
    const vendors = await Vendor.find().select("-password"); // this will fetch vendors and exclude password
    return res.status(200).json(vendors);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

vendorRouter.post("/vendor/tokenisvalid",auth, async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) {
      return res.json(false);
    }
    // verify the token
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) {
      return res.json(false);
    }

    // if verification failed(expired or invalid)
    const vendor = await Vendor.findById(verified.id);
    if (!vendor) {
      return res.json(false);
    }

    res.json(true);
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
});

vendorRouter.get("/get-vendor", auth, async (req, res) => {
  try { 
    const vendor = await Vendor.findById(req.user);
    res.json({ ...vendor._doc, token: req.token });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
});


module.exports = vendorRouter;
