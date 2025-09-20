const express = require("express");
const User = require("../models/user");
const Vendor = require("../models/vendor");
const bcrypt = require("bcryptjs");
const authRouter = express.Router();
const jwt = require("jsonwebtoken");

const { auth } = require("../middleware/auth");

// creating api for signup
authRouter.post("/api/signup", async (req, res) => {
  try {
    // object destructring(extracting values from object)
    const { fullName, email, password } = req.body;

    const existingVendorEmail = await Vendor.findOne({ email });

    if (!existingVendorEmail) {
      // finding the existing email
      const existintEmail = await User.findOne({ email });

      // if exist
      if (existintEmail) {
        return res
          .status(400)
          .json({ msg: "user with same email already exist" });
      } else {
        // generate a salt with cost factor of 10
        const salt = await bcrypt.genSalt(10);
        // hash the password using the generated salt
        const hashedPassword = await bcrypt.hash(password, salt);

        // if not then we will create new user
        let user = new User({ fullName, email, password: hashedPassword });
        // saving the user
        user = await user.save();
        res.json({ user });
      }
    } else {
      return res
        .status(400)
        .json({ msg: "vendor with same email already exist" });
    }
  } catch (error) {
    // if some error occurred
    res.status(500).json({ error: error.message });
  }
});

// creating api for signin
authRouter.post("/api/signin", async (req, res) => {
  try {
    const { email, password } = req.body;
    const existingEmail = await User.findOne({ email });
    if (!existingEmail) {
      return res.status(400).json({ msg: "User not found with this email" });
    } else {
      const isMatch = await bcrypt.compare(password, existingEmail.password);
      if (!isMatch) {
        return res.status(400).json({ msg: "Invalid User Credentails" });
      } else {
        const token = jwt.sign({ id: existingEmail._id }, "passwordKey", {
          expiresIn: "30m",
        });
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

// put route for updating user's state,locality and city
authRouter.put("/api/users/:id", async (req, res) => {
  try {
    // Extract the 'id' parameter from the request URl
    const { id } = req.params;

    // Extract the state and locality and city fiels from the request body
    const { state, city, locality } = req.body;

    // Find the user by id and update the fields
    // the {new:true} options ensures the updated document is returned
    const updatedUser = await User.findByIdAndUpdate(
      id,
      { state, city, locality },
      { new: true }
    );

    // If no user id found , return 404 page not found status with an error message

    if (!updatedUser) {
      return res.status(404).json({ error: "User not found" });
    }
    return res.status(200).json(updatedUser);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Fetch all users(exclude password)
authRouter.get("/api/users", async (req, res) => {
  try {
    const users = await User.find().select("-password"); // this will fetch users and exclude password
    return res.status(200).json(users);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Delete user or vendor api
authRouter.delete("/api/user/delete-account/:id", auth, async (req, res) => {
  try {
    // extract the id
    const { id } = req.params;
    // find the user with id
    const user = await User.findById(id);
    const vendor = await Vendor.findById(id);

    if (!user && !vendor) {
      return res.status(404).json({ msg: "user or vendor not found" });
    }

    if (user) {
      await User.findByIdAndDelete(id);
    } else if (vendor) {
      await Vendor.findByIdAndDelete(id);
    }

    return res.status(200).json({ msg: "user deleted successfully" });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
});

// check token validity
authRouter.post("/tokenisvalid",auth, async (req, res) => {
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
    const user = await User.findById(verified.id);
    if (!user) {
      return res.json(false);
    }

    res.json(true);
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
});

// Define  a get route for the auth router
authRouter.get("/", auth, async (req, res) => {
  try { 
    const user = await User.findById(req.user);
    res.json({ ...user._doc, token: req.token });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
});

module.exports = authRouter;
