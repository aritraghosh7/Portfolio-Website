const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const dotenv = require('dotenv');

dotenv.config();

const app = express();
app.use(express.json());
app.use(cors());

mongoose.connect(process.env.MONGO_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true
}).then(() => console.log("MongoDB Connected"))
.catch(err => console.log(err));

const contactSchema = new mongoose.Schema({
    fullName: String,
    email: String,
    phone: String,
    subject: String,
    message: String
});

const Contact = mongoose.model('Contact', contactSchema);

app.post('/api/contact', async (req, res) => {
    try {
        const newContact = new Contact(req.body);
        await newContact.save();
        res.status(201).json({ message: "Contact saved successfully!" });
    } catch (error) {
        res.status(500).json({ error: "Failed to save contact data" });
    }
});

app.listen(5000, () => console.log("Server running on port 5000"));
