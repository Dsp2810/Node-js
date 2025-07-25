const User = require('../models/Users')
const bcrypt = require("bcryptjs")
const jwt = require('jsonwebtoken')

const registerUser = async (req, res) => {
    try {
        const { name, email, password } = req.body;

        const existingUser = await User.findOne({ email });
        if (existingUser) return res.status(400).json({ msg: "User already Exist" });

        const salt = await bcrypt.genSalt(10);
        const hashedPass = await bcrypt.hash(password, salt);

        const user = new User({ name, email, password: hashedPass });
        await user.save();

        // Generate JWT token here
        const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, {
            expiresIn: "2d"
        });

        // Send token and user info back
        res.status(201).json({
            msg: "User registration successfully",
            token,
            user: {
                id: user._id,
                name: user.name,
                email: user.email
            }
        });
    } catch (err) {
        res.status(500).json({ msg: "Server Error", error: err.message });
    }
};


const loginUser = async (req, res) => {
    try {
        const { email, password } = req.body
        const user = await User.findOne({ email })

        if (!user) return res.status(404).json({ msg: "User not Found !" })
        console.log("User from DB:", user);


        const isMatch = await bcrypt.compare(password, user.password)
        if (!isMatch) return res.status(401).json({ msg: "Invalid Credentials " })

        const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, {
            expiresIn: "2d"
        });

        res.status(200).json({
            msg: "Login successful",
            token,
            user: {
                id: user._id,
                name: user.name,
                email: user.email
            }
        });

    }
    catch (err) {
        res.status(500).json({ msg: "Server error ", error: err.message })
    }
}
module.exports = { registerUser, loginUser }