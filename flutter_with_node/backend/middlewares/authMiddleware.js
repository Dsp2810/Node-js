const jwt = require("jsonwebtoken");
const User = require('../models/Users');

const product = async (req, res, next) => {
    try {
        const token = req.header('Authorization')?.replace('Bearer ', '').trim();

        if (!token) {
            return res.status(401).json({ msg: "No Token, access Denied" });
        }

        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        const user = await User.findById(decoded.id).select("-password");

        if (!user) {
            return res.status(404).json({ msg: "User not Found" });
        }

        req.user = user;
        next();
    } catch (err) {
        res.status(401).json({ msg: "Token is not valid", error: err.message });
    }
};

module.exports = product;
