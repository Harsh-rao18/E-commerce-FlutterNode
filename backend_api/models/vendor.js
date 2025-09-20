const mongoose =  require('mongoose');

const vendorschema = mongoose.Schema({

    fullName:{
        type:String,
        required:true,
        trim:true,
    },
    email:{
        type:String,
        required:true,
        trim:true,
        validate: {
            validator: (value) => {
                const result = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                return result.test(value);
            },
            message: "Please enter a valid email address"
        },
    },
    state:{
        type:String,
        default:"",
    },
    city:{
        type:String,
        default:"",
    },
    locality:{
        type:String,
        default:"",
    },
    role:{
        type:String,
        default:"vendor",
    },
    password:{
        type:String,
        required:true,
        validate:{
            validator : (value) => {
                return value.length >= 6;
            },
            message:"Password must be 6 character long",
        } 
    },
    storeName:{
        type:String,
        default:"",
    },
    storeImage:{
        type:String,
        default:"",
    },
    storeDescription:{
        type:String,
       default:"",
    },

});

const Vendor = mongoose.model("Vendor",vendorschema);

module.exports = Vendor;

