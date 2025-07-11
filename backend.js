const express = require('express')

const app = express()

app.use(express.json())

app.get('/',((req,res)=>{
    res.send("Welcome to the server")
}))
app.listen(3000,()=>{
    console.log("Server is running of http://localhost:3000")
    
})