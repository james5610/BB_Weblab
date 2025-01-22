const { exec } = require("child_process");
const express = require("express");
const app = express();
const util = require("util");
const execPromise = util.promisify(exec);

const run_econ_model = async (
  addResidualsSwitch,
  removeGrpeSwitch,
  removeGrpfSwitch,
  removeVuSwitch,
  removeShortageSwitch,
  updateGraphsSwitch
) => {
    
  // Convert to Strings
  addResidualsSwitch = String(addResidualsSwitch);
  removeGrpeSwitch = String(removeGrpeSwitch);
  removeGrpfSwitch = String(removeGrpfSwitch);
  removeVuSwitch = String(removeVuSwitch);
  removeShortageSwitch = String(removeShortageSwitch);
  updateGraphsSwitch = String(updateGraphsSwitch);

  const scriptPath = `./server/econ_model/code/Python/dynamic_simul.py ${addResidualsSwitch} ${removeGrpeSwitch} ${removeGrpfSwitch} ${removeVuSwitch} ${removeShortageSwitch} ${updateGraphsSwitch}`;


  command = `python ${scriptPath}`;
  const { stdout } = await execPromise(command);
  // console.log(`Script Output: ${stdout}`)
  return { stdout };
};

// run_econ_model();
module.exports = { run_econ_model };
