const mongoose = require('mongoose');

// a blueprint to store data
const userSchema = mongoose.Schema({
    fullName: {
        type: String,
        required: true,
        trim: true,
    },
    email: {
        type: String,
        required: true,
        trim: true,
        validate: {
            validator: (value) => {
                const result = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                return result.test(value);
            },
            message: "Please enter a valid email address"
        },
    },
    state: {
        type: String,
        default: "",
    },
    city: {
        type: String,
        default: "",
    },
    locality: {
        type: String,
        default: "",
    },
    password: {
        type: String,
        required: true,
        validate: {
            validator: (value) => {
                // check if password is at least 6 chracter long
                return value.length >= 6;
            },
            message: "Password must be 6 charcters long",
        },
    },
});

// creating a collection
const User = mongoose.model("User", userSchema);

module.exports = User;