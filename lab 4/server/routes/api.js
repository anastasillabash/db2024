const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');
const Member = require('../models/member');
const { ObjectId } = require('mongodb');

mongoose.connect('mongodb://localhost:27017/Gym');
mongoose.Promise = global.Promise;

mongoose
  .connect(db)
  .then(() => {
    console.log("Connected to MongoDB");
  })
  .catch((err) => {
    console.error("Connection error: ", err);
  });

router.get('/members', async (req, res) => {
    try {
      console.log('Get request for all');
      const us = await Member.find({}).exec();
      res.json(us);
    } catch (err) {
      console.error("Error retrieving: ", err);
      res.status(500).send("Error retrieving");
    }
});


router.get('/members/:id', async (req, res) => {
    try {
        const member = await mongoose.connection.db.collection('Members').findOne({ id: (req.params.id) });
        if (!member) {
            return res.status(404).json({ message: 'Member not found' });
        }
        res.json(member);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

router.post('/members', async (req, res) => {
    const new_member = req.body;
    try {
        const result = await mongoose.connection.db.collection('Members').insertOne(new_member);
        if (result.acknowledged === true && result.insertedId) {
            const insertedMember = await mongoose.connection.db.collection('Members').findOne({ _id: result.insertedId });
            res.status(201).json(insertedMember);
        } else {
            res.status(400).json({ message: 'Failed to insert a new member' });
        }
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
});

router.put('/members/:id', async (req, res) => {
    try {
        const result = await mongoose.connection.db.collection('Members').updateOne(
            { id: (req.params.id) },
            { $set: req.body }
        );
        if (result.modifiedCount === 0) {
            return res.status(404).json({ message: 'Member not found' });
        }
        res.json({ message: 'Member updated' });
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
});

router.delete('/members/:id', async (req, res) => {
    try {
        const result = await mongoose.connection.db.collection('Members').deleteOne({ id: (req.params.id) });
        if (result.deletedCount === 0) {
            return res.status(404).json({ message: 'Member not found' });
        }
        res.json({ message: 'Member deleted' });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

module.exports = router; 