const express = require("express")
const dotenv = require("dotenv")
const cors = require("cors")
const connectDb = require("./config/db")
const { listIndexes } = require("./models/Users")

dotenv.config()
connectDb();
const port = process.env.PORT

const app = express()
app.use(cors())
app.use(express.json())
app.use('/uploads', express.static(path.join(__dirname,'uploads')))


app.use("/api/auth", require("./routes/authRoutes"))
app.use("/api/products", require("./routes/productRoutes"))

app.listen(process.env.PORT, () => {
  console.log(`Server is running on http://localhost:${process.env.PORT}`);
});
