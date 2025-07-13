// const express = require('express')

// const app = express()

// app.use(express.json())

// app.get('/',((req,res)=>{
//     res.send("Welcome to the server")
// }))
// app.listen(3000,()=>{
//     console.log("Server is running of http://localhost:3000")

// })



/* 
        Now understanding the CRUD(  create,read,Update,Delete    )
        Operations for this....


 */

// -- >
// const express = require('express');
// const app = express();
// app.use(express.json());

// // Simulated database
// let arr_data = [];

// // 1️⃣ GET all expenses
// app.get('/arr_data', (req, res) => {
//     res.json(arr_data);
// });

// // 2️⃣ POST a new expense
// app.post('/arr_data', (req, res) => {
//     const expense = {
//         id: Date.now(), // ✅ Correct usage
//         title: req.body.title,
//         amount: req.body.amount
//     };
//     arr_data.push(expense);
//     res.status(201).json(expense);
// });

// // 3️⃣ DELETE an expense by ID
// app.delete("/arr_data/:id", (req, res) => {
//     const id = parseInt(req.params.id, 10);
//     const originalLength = arr_data.length;

//     arr_data = arr_data.filter(e => e.id !== id);

//     if (arr_data.length === originalLength) {
//         return res.status(404).json({ message: "Expense not found" });
//     }

//     res.json({ message: "Expense Deleted" });
// });

// // Start the server
// app.listen(3000, () => {
//     console.log("✅ Server is running on http://localhost:3000");
// });

// // now the function for the updatation ...

// // put is used for the upating the data

// app.put("/arr_data/:id",(req,res)=>{
//     const id = parseInt(req.params.id) // params is used for geeting the data from the URL.....
//     const {title,amount} = req.body
//     const index = arr_data.findIndex(e=>e.id==id)
//     if(index==-1){
//         return res.status(404).json({message:"No data found"})
//     }
//     arr_data[index].title=title
//     arr_data[index].amount=amount
//     res.json({message:"Data updated",data:arr_data[index]})
// })

//  < ------

// now the isuue comes when we restart the server the all data is being erased for that we have to store the data 
// .... 
// in some storage for that we have to use the "FS" file system and in theat .json


// now from this i have learned that for the Functions as the
// JSON.stringify === > converts the js object or  array to the JSON structure
// as the JSON.parse = > converts the json data into array or string

const fs = require("fs")
const filepath = "./data.json"

function readdata() {
    try {
        const jsonData = fs.readFileSync(filepath, 'utf-8')
        return JSON.parse(jsonData)
    }
    catch (err) { return [] }
}
function savedata(data) {
    fs.writeFileSync(filepath, JSON.stringify(data, null, 2))
}

const express = require('express');
const { stringify } = require("querystring")
const app = express();
app.use(express.json());

// Simulated database
let arr_data = readdata();

// 1️⃣ GET all expenses
app.get('/arr_data', (req, res) => {
    res.json(arr_data);
});

// 2️⃣ POST a new expense
app.post('/arr_data', (req, res) => {
    const expense = {
        id: Date.now(), // ✅ Correct usage
        title: req.body.title,
        amount: req.body.amount
    };
    arr_data.push(expense);
    savedata(arr_data)
    res.status(201).json(expense);
});

// 3️⃣ DELETE an expense by ID
app.delete("/arr_data/:id", (req, res) => {
    const id = parseInt(req.params.id, 10);
    const originalLength = arr_data.length;

    arr_data = arr_data.filter(e => e.id !== id);

    if (arr_data.length === originalLength) {
        return res.status(404).json({ message: "Expense not found" });
    }
    savedata(arr_data)

    res.json({ message: "Expense Deleted" });
});

// Start the server
app.listen(3000, () => {
    console.log("✅ Server is running on http://localhost:3000");
});

// now the function for the updatation ...

// put is used for the upating the data

app.put("/arr_data/:id", (req, res) => {
    const id = parseInt(req.params.id) // params is used for geeting the data from the URL.....
    const { title, amount } = req.body
    const index = arr_data.findIndex(e => e.id == id)
    if (index == -1) {
        return res.status(404).json({ message: "No data found" })
    }
    arr_data[index].title = title
    arr_data[index].amount = amount
    savedata(arr_data)
    res.json({ message: "Data updated", data: arr_data[index] })
})
