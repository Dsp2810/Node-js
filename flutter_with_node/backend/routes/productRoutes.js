const express = require('express')
const router = express.Router()
const product = require('../middlewares/authMiddleware')
const multer = require('multer')

const {
    getProducts,
    addProduct,
    toggleFav,
    uploadProductWithImage
} = require("../controllers/productController")
router.get('/', getProducts)

// making the storage 
const storage = multer.diskStorage(
    {
        destination: function (req, file, cb) {
            cb(null, 'uploads/')
        },
        filename: function (req, file, cb) {
            cb(null, Date.now() + ' - ' + file.originalname)
        }
    }
)

const upload = multer({ storage: storage })
router.post('/upload', product, upload.single('image'), uploadProductWithImage)

router.post('/add', product, addProduct)
router.post('/fav/:id', toggleFav)


module.exports = router