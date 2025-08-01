const Product = require('../models/product');
const path = require('path')

// // Get all products
// const getProducts = async (req, res) => {
//   try {
//     const products = await Product.find().sort({ createdAt: -1 });
//     res.json(products);
//   } catch (err) {
//     res.status(500).json({ msg: "Server error", error: err.message });
//   }
// };

const getMyProducts = async (req, res) => {
  try {
    const products = await Product.find({ user: req.user._id }).sort({ createdAt: -1 })
    res.status(200).json(products)
  }
  catch (err) {
    console.log("Error in getMyProducts:", err)
    res.status(500).json({ msg: "Server Error", error: err.message })
  }
}
// Add a new product
const addProduct = async (req, res) => {
  try {
    const { name, price, description, image, isFav, quantity } = req.body;
    const product = new Product({ name, price, description, image, isFav: isFav ?? false, quantity, user: req.user._id });
    await product.save();
    res.status(201).json(product);
  } catch (err) {
    res.status(500).json({ msg: "Server error", error: err.message });
  }
};

// Toggle favorite status of a product
const toggleFav = async (req, res) => {
  try {
    const productId = req.params.id;
    const product = await Product.findById(productId);

    if (!product) {
      return res.status(404).json({ msg: "Product not found" });
    }

    product.isFav = !product.isFav; // Toggle
    await product.save();

    res.json({ msg: "Favorite status updated", product });
  } catch (err) {
    res.status(500).json({ msg: "Server error", error: err.message });
  }
};

const imageUrl = `/uploads/${req.file.filename}`
const uploadProductWithImage = async (req, res) => {

  try {
    const { name, price, description, isFav, quantity } = req.body
    if (!req.file) {
      return res.status(400).json({ msg: "No Image File Uploaded" })
    }
    const imagePath = `${req.protocol}://${req.get("host")}/uploads/${req.file.filename}`

    const product = new Product({
      name, price, description, image: imagePath, isFav: isFav ?? false, quantity, user: req.user._id
    })
    await product.save()
    res.status(201).json(product)
  }
  catch (err) {
    res.status(500).json({ msg: "Server Error ", error: err.message })
  }
}

module.exports = {
  getMyProducts,
  addProduct,
  toggleFav,
  uploadProductWithImage
};
