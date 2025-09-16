const jwt = require("jsonwebtoken");
const User = require("../models/user");
const Vendor = require("../models/vendor");

// Authentication middleware
// this middleware function checks that user is authenticated

const auth = async (req, res, next) => {
  try {
    // extract the token from the request header
    const token = req.header("x-auth-token");
    // if no token is provided , return 401(unauthorized) response with an error message
    if (!token) {
      return res
        .status(401)
        .json({ msg: "No authentication token, authorization denied" });
    }

    // verify the jwt token using the secret key
    const verified = jwt.verify(token, "passwordKey");
    // if token verification failde , return 401(unauthorized) response with an error message
    if (!verified) {
      return res
        .status(401)
        .json({ msg: "Token verification failed, authorization denied" });
    }

    // find the user and vendor in the database using the id stored in the token payload
    const user =
      (await User.findById(verified.id)) ||
      (await Vendor.findById(verified.id));
    if (!user) {
      return res
        .status(401)
        .json({ msg: "user or vendor not found, authorization denied" });
    }

    // attch the authenticated user to request objects
    // this makes user data available to any subsequent middleware or route handlers
    req.user = user;

    // also attch the  token to request object in case is needed later
    req.token = token;

    // proceed to the next middleware or route
    next();
  } catch (error) {
    // if some error occurred
    res.status(500).json({ error: error.message });
  }
};

// vendor authentication middleware
// this middleware ensures that the user making the request is a vendor
// it should be used for routes that only vendor can access
const vendorAuth = async (req, res, next) => {
  try {
    if (!req.user.role || req.user.role !== "vendor") {
      // if the user is not a vendor return 403 (forbidden)
      return res.status(403).json({ msg: "Acess denied" });
    }

    // if vendor , proceed to the next
    next();
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = {auth,vendorAuth};
