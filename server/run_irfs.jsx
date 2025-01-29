const { exec } = require("child_process");
const express = require("express");
const app = express();
const util = require("util");
const execPromise = util.promisify(exec);

const run_irfs = async (
  grpeSlider,
  grpfSlider,
  vuSlider,
  shortageSlider,
  rhoGrpeSlider,
  rhoGrpfSlider,
  rhoVuSlider,
  rhoShortageSlider
) => {

  const scriptPath = `./server/econ_model/code/Python/simulation_full_irfs.py ${grpeSlider} ${grpfSlider} ${vuSlider} ${shortageSlider} ${rhoGrpeSlider} ${rhoGrpfSlider} ${rhoVuSlider} ${rhoShortageSlider}`;
  // const scriptPath = `./server/econ_model/code/Python/simulation_full_irfs.py`;


  command = `python ${scriptPath}`;
  const { stdout } = await execPromise(command);
  // console.log(`Script Output: ${stdout}`)

  return { stdout };
};

module.exports = { run_irfs };
