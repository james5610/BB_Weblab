const { exec } = require("child_process");
const express = require("express");
const app = express();
const util = require("util");
const execPromise = util.promisify(exec);

const run_irfs = async (
  addGrpeSwitch,
  addGrpfSwitch,
  addVuSwitch,
  addShortageSwitch,
) => {


  // Convert to Strings
  addGrpeSwitch = String(addGrpeSwitch);
  addGrpfSwitch = String(addGrpfSwitch);
  addVuSwitch = String(addVuSwitch);
  addShortageSwitch = String(addShortageSwitch);

  const scriptPath = `./server/econ_model/code/Python/simulation_full_irfs.py ${addGrpeSwitch} ${addGrpfSwitch} ${addVuSwitch} ${addShortageSwitch}`;
  // const scriptPath = `./server/econ_model/code/Python/simulation_full_irfs.py`;


  command = `python ${scriptPath}`;
  const { stdout } = await execPromise(command);
  // console.log(`Script Output: ${stdout}`)

  return { stdout };
};

module.exports = { run_irfs };
