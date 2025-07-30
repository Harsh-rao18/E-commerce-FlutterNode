const express = require('express');
const Order = require('../models/order');

const orderRouter = express.Router();

// Post route for cresting orders
orderRouter.post('/api/orders',async (req,res) => {
    try {
        const {fullName,email,state,city,locality,productName,productPrice,quantity,category,image,buyerId,vendorId} = req.body;

        const createdAt = new Date().getMilliseconds() // Get the current date

        // create new order instance 
        const order = new Order({fullName,email,state,city,locality,productName,productPrice,quantity,category,image,buyerId,vendorId,createdAt});
        await order.save();

        return res.status(201).json(order);
    } catch (error) {
        res.status(500).json({error:error.message});
    }
});

// Get routes for fetching orders by Buyer Id
orderRouter.get('/api/orders/:buyerId',async (req,res) => {
    try {
        const {buyerId} = req.params;

        const orders = await Order.find({buyerId});
        if(orders.length == 0){
            return res.status(404).json({msg:"No Orders found for this buyer"}); 
        }

        return res.status(200).json(orders);

    } catch (error) {
        res.status(500).json({error:error.message});
    }
})

module.exports = orderRouter;