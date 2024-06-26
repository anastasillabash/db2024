const mongoose = require('mongoose');

const Schema = mongoose.Schema;

const MemberSchema = new Schema({
    id: Number,
    name: String,
    surname: String,
    sex : String,
    age: Number,
    phone: String
});

module.exports = mongoose.model('Member', MemberSchema, 'Members');