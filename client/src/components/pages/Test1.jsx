import React, { useContext, useEffect, useRef } from "react";
import { GoogleLogin, googleLogout } from "@react-oauth/google";
import "../../utilities.css";
import "./Test1.css";
import { get, post } from "../../utilities";
import { UserContext } from "../App";
import StackedBarChart from "./StackedBarChart";

const Skeleton = () => {
  const { userId, handleLogin, handleLogout } = useContext(UserContext);

  const run_econ_model = () => {
    let params = {
      addResidualsSwitch: addResidualsSwitch.checked,
      removeGrpeSwitch: removeGrpeSwitch.checked,
      removeGrpfSwitch: removeGrpfSwitch.checked,
      removeVuSwitch: removeVuSwitch.checked,
      removeShortageSwitch: removeShortageSwitch.checked,
      updateGraphsSwitch: updateGraphsSwitch.checked,
      dummyVar: false, // We add this dummy var so a random "?" doesn't appear at end of get request
    };
    let queryString = new URLSearchParams(params).toString();
    let url = `./api/run_econ_model?${queryString} `;
    get(url).then((results) => {
      console.log(results);
    });
  };

  const update_data = () => {
    get("./api/update_data").then((data) => {
      console.log(data);
    });
  };

  //****************** Option Switches ********************************

  // Add an event listener for toggle changes
  // Select the checkbox and status text

  useEffect(() => {
    // addResiduals Switch
    const addResidualsSwitch = document.getElementById("addResidualsSwitch");
    const addResidualsStatus = document.getElementById("addResidualsStatus");

    addResidualsSwitch.addEventListener("change", () => {
      if (addResidualsSwitch.checked) {
        addResidualsStatus.textContent = "ON";
      } else {
        addResidualsStatus.textContent = "OFF";
      }
    });

    // removeGrpe Switch
    const removeGrpeSwitch = document.getElementById("removeGrpeSwitch");
    const removeGrpeStatus = document.getElementById("removeGrpeStatus");

    removeGrpeSwitch.addEventListener("change", () => {
      if (removeGrpeSwitch.checked) {
        removeGrpeStatus.textContent = "ON";
      } else {
        removeGrpeStatus.textContent = "OFF";
      }
    });

    // removeGrpf Switch
    const removeGrpfSwitch = document.getElementById("removeGrpfSwitch");
    const removeGrpfStatus = document.getElementById("removeGrpfStatus");

    removeGrpfSwitch.addEventListener("change", () => {
      if (removeGrpfSwitch.checked) {
        removeGrpfStatus.textContent = "ON";
      } else {
        removeGrpfStatus.textContent = "OFF";
      }
    });

    // removeVu Switch
    const removeVuSwitch = document.getElementById("removeVuSwitch");
    const removeVuStatus = document.getElementById("removeVuStatus");

    removeVuSwitch.addEventListener("change", () => {
      if (removeVuSwitch.checked) {
        removeVuStatus.textContent = "ON";
      } else {
        removeVuStatus.textContent = "OFF";
      }
    });

    // removeShortage Switch
    const removeShortageSwitch = document.getElementById("removeShortageSwitch");
    const removeShortageStatus = document.getElementById("removeShortageStatus");

    removeShortageSwitch.addEventListener("change", () => {
      if (removeShortageSwitch.checked) {
        removeShortageStatus.textContent = "ON";
      } else {
        removeShortageStatus.textContent = "OFF";
      }
    });

    // updateGraphs Switch
    const updateGraphsSwitch = document.getElementById("updateGraphsSwitch");
    const updateGraphsStatus = document.getElementById("updateGraphsStatus");

    updateGraphsSwitch.addEventListener("change", () => {
      if (updateGraphsSwitch.checked) {
        updateGraphsStatus.textContent = "ON";
      } else {
        updateGraphsStatus.textContent = "OFF";
      }
    });
  }, []);

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
          run_econ_model();
          update_data();
        }}
      >
        <div className="Run-button" />
      </div>

      {/* Lay out flexboxes */}
      <div className="container">
        <div className="leftDiv">
          {/* Grid laying out options */}

          <div className="Grid-container">
            {/* Row 1 Col 1 */}
            <div className="Text-column">
              <p>Add Residuals</p>
            </div>

            {/* Row 1 Col 2 */}
            <div className="switch-container">
              <label className="switch">
                <input type="checkbox" id="addResidualsSwitch" />
                <span className="slider"></span>
              </label>
              <p id="addResidualsStatus">OFF</p>
            </div>

            {/* Row 2 Col 1*/}
            <div className="Text-column">
              <p>Remove GRPE</p>
            </div>

            {/* Row 2 Col 2 */}
            <div className="switch-container">
              <label className="switch">
                <input type="checkbox" id="removeGrpeSwitch" />
                <span className="slider"></span>
              </label>
              <p id="removeGrpeStatus">OFF</p>
            </div>

            {/* Row 3  Col 1*/}
            <div className="Text-column">
              <p>Remove GRPF</p>
            </div>

            {/* Row 3 Col 2 */}
            <div className="switch-container">
              <label className="switch">
                <input type="checkbox" id="removeGrpfSwitch" />
                <span className="slider"></span>
              </label>
              <p id="removeGrpfStatus">OFF</p>
            </div>

            {/* Row 4  Col 1*/}
            <div className="Text-column">
              <p>Remove V/U</p>
            </div>

            {/* Row 4 Col 2 */}
            <div className="switch-container">
              <label className="switch">
                <input type="checkbox" id="removeVuSwitch" />
                <span className="slider"></span>
              </label>
              <p id="removeVuStatus">OFF</p>
            </div>

            {/* Row 5  Col 1*/}
            <div className="Text-column">
              <p>Remove Shortage</p>
            </div>

            {/* Row 5 Col 2 */}
            <div className="switch-container">
              <label className="switch">
                <input type="checkbox" id="removeShortageSwitch" />
                <span className="slider"></span>
              </label>
              <p id="removeShortageStatus">OFF</p>
            </div>

            {/* Row 6  Col 1*/}
            <div className="Text-column">
              <p>Update Graphs</p>
            </div>

            {/* Row 6 Col 2 */}
            <div className="switch-container">
              <label className="switch">
                <input type="checkbox" id="updateGraphsSwitch" />
                <span className="slider"></span>
              </label>
              <p id="updateGraphsStatus">OFF</p>
            </div>
          </div>
        </div>
        <div className="rightDiv">
          {/* Graph Staging Grounds */}
          <StackedBarChart />
        </div>
      </div>
    </>
  );
};

export default Skeleton;
