const express = require('express')
const router = express.Router()
const product=require('../middlewares/authMiddleware')

const {
    getProducts,
    addProduct,
    toggleFav
} = require("../controllers/productController")
router.get('/',getProducts)

router.post('/add',addProduct)
router.post('/fav/:id',toggleFav)


module.exports = router