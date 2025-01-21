import React, { useState, useEffect, useContext } from "react";
import { GoogleLogin, googleLogout } from "@react-oauth/google";

import "../../utilities.css";
import "./Test1.css";
import { UserContext } from "../App";
import { get, post } from "../../utilities";
// import { run_econ_model } from "../../../../server/run_econ_model";
// import { update_data } from "../../../../server/update_data";
// const base_dir = window.location.href;

const Skeleton = () => {
  const { userId, handleLogin, handleLogout } = useContext(UserContext);

  const run_econ_model = () => {
    get("./api/run_econ_model").then((results) => {
      console.log(results);
    });
  };

  const update_data = () => {
    get("./api/update_data").then((data) => {
      console.log(data);
    });
  };

  //Option Switches
  const [grpe_op, set_grpe_op] = useState(false);
  const update_grpe_op = () => {
    if (grpe_op === true) {
      set_grpe_op(false);
    } else {
      set_grpe_op(true);
    }
  };

  return (
    <>
      {userId ? (
        <button
          onClick={() => {
            googleLogout();
            handleLogout();
          }}
        >
          Logout
        </button>
      ) : (
        <GoogleLogin onSuccess={handleLogin} onError={(err) => console.log(err)} />
      )}

      {/* Run model*/}
      <div
        className="Run-buttonContainer"
        onClick={() => {
          console.log(grpe_op);
          run_econ_model();
          update_data();
        }}
      >
        <div className="Run-button" />
      </div>

      {/*Option Switches */}
      <div
        className="Off-buttonContainer"
        onClick={() => {
          update_grpe_op();
        }} //Note: For some reason, if we were to console.log the variable here, it would return the old value. For some reason, it doesn't console.log correctly until it exits this section
      >
        <input
          type="checkbox"
          id="toggle"
          onClick={(e) => {
            e.stopPropagation();
          }} // Prevent parent click from firing, otherwise clicks twice
        />
        <label for="toggle" class="Off-button"></label>
      </div>

      {/* Second iteration at Option Switch */}
      <div class="switch-container">
        <label class="switch">
          <input type="checkbox" id="toggleSwitch" />
          <span class="slider"></span>
        </label>
        <p id="switchStatus">OFF</p>
      </div>

      {/* Grid laying out options */}
      <body>
        <div class="Grid-container">
          {/* Row 1 */}
          <div class="Text-column">
            <p>Include GRPE</p>
          </div>
          <div
            className="Off-buttonContainer"
            onClick={() => {
              update_grpe_op();
            }} //Note: For some reason, if we were to console.log the variable here, it would return the old value. For some reason, it doesn't console.log correctly until it exits this section
          >
            <input
              type="checkbox"
              id="toggle"
              onClick={(e) => {
                e.stopPropagation();
              }} // Prevent parent click from firing, otherwise clicks twice
            />
            <label for="toggle" class="Off-button"></label>
          </div>

          {/* Row 2 */}
          <div class="Text-column">
            <p>Include GRPF</p>
          </div>
          <div class="Image-column">
            <img
              src="http://localhost:5173/src/components/assets/on_switch_v1.png"
              alt="Switch Image"
            />
          </div>

          {/* Row 3 */}
          <div class="Text-column">
            <p>Include GRPF</p>
          </div>
          <div class="Image-column">
            <img
              src="http://localhost:5173/src/components/assets/on_switch_v1.png"
              alt="Switch Image"
            />
          </div>

          {/* Row 4 */}
          <div class="Text-column">
            <p>Include GRPF</p>
          </div>
          <div class="Image-column">
            <img
              src="http://localhost:5173/src/components/assets/on_switch_v1.png"
              alt="Switch Image"
            />
          </div>

          {/* Row 5 */}
          <div class="Text-column">
            <p>Include GRPF</p>
          </div>
          <div class="Image-column">
            <img
              src="http://localhost:5173/src/components/assets/on_switch_v1.png"
              alt="Switch Image"
            />
          </div>

          {/* Row 6 */}
          <div class="Text-column">
            <p>Include GRPF</p>
          </div>
          <div class="Image-column">
            <img
              src="http://localhost:5173/src/components/assets/on_switch_v1.png"
              alt="Switch Image"
            />
          </div>
        </div>
      </body>
    </>
  );
};

export default Skeleton;
