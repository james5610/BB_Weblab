import React, { useContext } from "react";
import { GoogleLogin, googleLogout } from "@react-oauth/google";

import "../../utilities.css";
import "./Test1.css";
import { UserContext } from "../App";
import {PythonShell} from 'python-shell';t

let options = {
  scriptPath: "../../../../server/econ_model/code/Python",
  args: [False, False, False, False, False, True]

};
PythonShell.run('dynamic_simul.py', options).then(messages=>{
  console.log('results: %j', results);
});