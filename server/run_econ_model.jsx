const { exec } = require('child_process');
const scriptPath = "./server/econ_model/code/Python/dynamic_simul.py";
const express = require("express");
const app = express();
const util = require('util');
const execPromise = util.promisify(exec);

const run_econ_model = async() => {
    
    command = `python ${scriptPath}`;
    const{stdout} = await execPromise(command);
    // console.log(`Script Output: ${stdout}`)
    return {stdout};
}
// run_econ_model();
module.exports = {run_econ_model};