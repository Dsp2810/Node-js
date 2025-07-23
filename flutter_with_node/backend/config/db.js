const mongoose = require("mongoose")
const connectDb = async()=>{
    try{
        await mongoose.connect(process.env.MONGO_URI);
        console.log("Mongo Db connected")
    }
    catch(err){
        console.log(error.message)
        process.exit(1)
    }
};
module.exports = connectDb