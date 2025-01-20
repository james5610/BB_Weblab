
const { exec } = require('child_process');
const scriptPath = "./econ_model/code/Python/dynamic_simul.py";
const express = require("express");
const app = express();

// app.get("/api/run_econ_model", (req, res) => {
//     res.send("{message: This is an API!!");
// });

// app.get("*", (req,res) => {
//     res.status(404).send({message: "Not Found"})
// })

const run_econ_model = () => {
    command = `python ${scriptPath} False False False False False False`;
    exec(command, (error, stdout, stderr) => {
        if(error){
            console.error(`exec error ${error}`);
            return;
        }
        console.log(`stdout: ${stdout}`);
    });
}
run_econ_model();
// console.log(stdout);

const test_function = () => {
    return "hello";
}
module.exports = {run_econ_model, test_function};