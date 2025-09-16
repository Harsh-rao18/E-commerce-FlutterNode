const express = require('express');
const Order = require('../models/order');

const orderRouter = express.Router();

const {auth,vendorAuth} = require('../middleware/auth')

// Post route for creating orders
orderRouter.post('/api/orders',auth,async (req,res) => {
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
orderRouter.get('/api/orders/:buyerId',auth,async (req,res) => {
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
});

// Delete route for deleting a specific order by Id
orderRouter.delete("/api/orders/:id",auth,async (req,res) => {
    try {
        const {id} = req.params;
        const deletedOrder = await Order.findByIdAndDelete(id);

        if (!deletedOrder) {
            // if no order was found with provided Id return 404
             return res.status(404).json({msg:"No Orders found"}); 
        } else {
            // if the order was successfully deleted, return 200 status with success msg
             return res.status(200).json({msg : "Order was deleted successfully"});
        }
    } catch (error) {
         res.status(500).json({error:error.message});
    }
});


// Get routes for fetching orders by Vendor Id
orderRouter.get('/api/orders/vendors/:vendorId',auth,vendorAuth,async (req,res) => {
    try {
        const {vendorId} = req.params;

        const orders = await Order.find({vendorId});
        if(orders.length == 0){
            return res.status(404).json({msg:"No Orders found for this vendor"}); 
        }

        return res.status(200).json(orders);

    } catch (error) {
        res.status(500).json({error:error.message});
    }
});

orderRouter.patch('/api/orders/:id/delivered',async (req,res) => {
    try {
        const {id} = req.params;
        const updatedOrder =  await Order.findByIdAndUpdate(id,{delivered:true,processing:false},{new:true});

        if (!updatedOrder) {
            res.status(404).json({msg:"order not found"});
        } else {
           res.status(200).json(updatedOrder); 
        }
    } catch (error) {
        res.status(500).json({error:error.message});
    }
});
orderRouter.patch('/api/orders/:id/processing',async (req,res) => {
    try {
        const {id} = req.params;
        const updatedOrder =  await Order.findByIdAndUpdate(id,{processing:false,delivered:false},{new:true});

        if (!updatedOrder) {
            res.status(404).json({msg:"order not found"});
        } else {
           res.status(200).json(updatedOrder); 
        }
    } catch (error) {
        res.status(500).json({error:error.message});
    }
});

// api to fetch all orders
orderRouter.get('/api/orders',async (req,res) => {
    try {
        const orders = await Order.find();
        return res.status(200).send(orders);
    } catch (error) {
        res.status(500).json({error:error.message});
    }
});

module.exports = orderRouter;