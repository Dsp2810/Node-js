const express = require('express')
const router = express.Router()
const product = require('../middlewares/authMiddleware')
const multer = require('multer')
const path = require('path')

const {
    getMyProducts,
    addProduct,
    toggleFav,
    uploadProductWithImage,
    updateProduct
} = require("../controllers/productController")

// making the storage 
const storage = multer.diskStorage(
    {

        destination: function (req, file, cb) {
            cb(null, 'uploads/')
        },
        filename: function (req, file, cb) {
            const productName = req.body.name || 'Product'
            const userId = req.body.userId || 'user'
            const date = new Date().toISOString().split('T')[0]
            const ext = path.extname(file.originalname)

            const cleanName = `${productName}_${userId}_${date}${ext}`.replace(/\s+/g, '_');
            cb(null, cleanName)
        }
    }
)

const upload = multer({ storage: storage })

router.get('/', product, getMyProducts)
router.post('/upload', product, upload.single('image'), uploadProductWithImage)

router.post('/add', product, addProduct)
router.post('/fav/:id', toggleFav)
router.put("edit/:id", product, updateProduct)


module.exports = router