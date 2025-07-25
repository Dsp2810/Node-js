const express = require('express')
const authmiddleware = require('../middlewares/authMiddleware')
const router = express.Router()
const { registerUser,
    loginUser } =
    require("../controllers/authController")

router.post('/register', registerUser)
router.post('/login', authmiddleware,loginUser)

module.exports = router

