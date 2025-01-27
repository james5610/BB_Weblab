import React, { useState, useContext, useEffect, useRef, createContext } from "react";
import { GoogleLogin, googleLogout } from "@react-oauth/google";
import "../../utilities.css";
import "./Test1.css";
import { get, post } from "../../utilities";
import { UserContext } from "../App";
import Chart_Irfs from "./ChartIrfs";
// Create the DataContext for shared state; helps update graph when run button is pressed
import { DataProvider } from "./DataContext";
import { DataContext } from "./DataContext";

const Irfs = () => {
  const { userId, handleLogin, handleLogout } = useContext(UserContext);

  const run_irfs = async (setSharedData) => {
    // const { setSharedData } = useContext(DataContext);

    let params = {
      addGrpeSwitch: addGrpeSwitch.checked,
      addGrpfSwitch: addGrpfSwitch.checked,
      addVuSwitch: addVuSwitch.checked,
      addShortageSwitch: addShortageSwitch.checked,
    };

    await get("/api/run_irfs", params).then((results) => {
      // console.log(`Results under line 26 Test1.jsx: ${JSON.stringify(results)}`);
      console.log({ results });
    });
    let response = await get("./api/update_irf_data");
    await setSharedData(response);

  };

  // const update_irf_data = () => {
  //   get("/api/update_irf_data").then((data) => {
  //     console.log(data);
  //   });
  // };

  //****************** Option Switches ********************************

  // Add an event listener for toggle changes
  // Select the checkbox and status text

  useEffect(() => {
    // addGrpe Switch
    const addGrpeSwitch = document.getElementById("addGrpeSwitch");
    const addGrpeStatus = document.getElementById("addGrpeStatus");

    addGrpeSwitch.addEventListener("change", () => {
      if (addGrpeSwitch.checked) {
        addGrpeStatus.textContent = "ON";
      } else {
        addGrpeStatus.textContent = "OFF";
      }
    });

    // addGrpf Switch
    const addGrpfSwitch = document.getElementById("addGrpfSwitch");
    const addGrpfStatus = document.getElementById("addGrpfStatus");

    addGrpfSwitch.addEventListener("change", () => {
      if (addGrpfSwitch.checked) {
        addGrpfStatus.textContent = "ON";
      } else {
        addGrpfStatus.textContent = "OFF";
      }
    });

    // addVu Switch
    const addVuSwitch = document.getElementById("addVuSwitch");
    const addVuStatus = document.getElementById("addVuStatus");

    addVuSwitch.addEventListener("change", () => {
      if (addVuSwitch.checked) {
        addVuStatus.textContent = "ON";
      } else {
        addVuStatus.textContent = "OFF";
      }
    });

    // addShortage Switch
    const addShortageSwitch = document.getElementById("addShortageSwitch");
    const addShortageStatus = document.getElementById("addShortageStatus");

    addShortageSwitch.addEventListener("change", () => {
      if (addShortageSwitch.checked) {
        addShortageStatus.textContent = "ON";
      } else {
        addShortageStatus.textContent = "OFF";
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

  // For Updating Graph whenever run button is pressed
  // "Run" button component
  const RunButton = () => {
    const { setSharedData } = useContext(DataContext);
    const handleRun = async () => {
    //   try {
    //     // Define fetchData
    //     const fetchData = async () => {
    //       try {
    //         // Update Data
    //         let response = await get("./api/update_irf_data");
    //         return response;
    //       } catch (error) {
    //         console.error("Error fetching data in Chart_Irfs:", error);
    //         return [];
    //       }
    //     };

        // run_irfs().then(
        //   fetchData().then((response) => {
        //     console.log(`Shared data:`);
        //     console.log(response);
        //     setSharedData(response);
        //   })
        // );

        // setSharedData(response); // Update the shared data
        // console.log(response);
        // console.log(sharedData);
      // } catch (error) {
      //   console.error("Error updating data:", error);
      // }
      run_irfs(setSharedData);
    };

    return <button onClick={handleRun}>Update Graph</button>;
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
      <div>
        <p>Steps to run model</p>
        <li>Toggle options on left</li>
        <li>Hit the RUN Button to run the model</li>
        <li>Hit the Update Graph Button to view changes</li>
        <li>
          Note that the RUN button and then the Update Graph button must be pressed in that order
          each time the graph wants to be updated
        </li>
        <li>
          Also note that because of the way we initialize our equations, the first four data points
          will always be the same
        </li>
        <li>
          This model shows GCPI, or CPI inflation and how it is affected by the variou toggles. In
          the future, additional variables will be available, as well as a way to see the
          contribution of each toggle to headline numbers.
        </li>
        <li>
          You can view various messages and checks in the console. In the future, these will be
          removed.
        </li>
        <p></p>
        <p></p>
        <p></p>
        <p></p>
        <p></p>
        <p></p>
        <p></p>
        <p></p>
        <p></p>
        <p></p>
        <p></p>
        <p></p>
        <p></p>
        <p></p>
        <p></p>
        <p></p>
      </div>

      {/* Run model
      <div
        className="Run-buttonContainer"
        onClick={() => {
          // run_irfs();
          // update_irf_data();
          // console.log(`From Run button:`)
          // console.log(sharedData)
        }}
      >
        <div className="Run-button" />
      </div> */}

      {/* Lay out flexboxes */}
      <div className="container">
        <div className="leftDiv">
          {/* Grid laying out options */}

          <div className="Grid-container">
            {/* Row 1 Col 1 */}
            <div className="Text-column">
              <p>Add GRPE</p>
            </div>

            {/* Row 1 Col 2 */}
            <div className="switch-container">
              <label className="switch">
                <input type="checkbox" id="addGrpeSwitch" />
                <span className="slider"></span>
              </label>
              <p id="addGrpeStatus">OFF</p>
            </div>

            {/* Row 2 Col 1*/}
            <div className="Text-column">
              <p>Add GRPF</p>
            </div>

            {/* Row 2 Col 2 */}
            <div className="switch-container">
              <label className="switch">
                <input type="checkbox" id="addGrpfSwitch" />
                <span className="slider"></span>
              </label>
              <p id="addGrpfStatus">OFF</p>
            </div>

            {/* Row 3  Col 1*/}
            <div className="Text-column">
              <p>Add V/U</p>
            </div>

            {/* Row 3 Col 2 */}
            <div className="switch-container">
              <label className="switch">
                <input type="checkbox" id="addVuSwitch" />
                <span className="slider"></span>
              </label>
              <p id="addVuStatus">OFF</p>
            </div>

            {/* Row 4  Col 1*/}
            <div className="Text-column">
              <p>Add Shortage</p>
            </div>

            {/* Row 4 Col 2 */}
            <div className="switch-container">
              <label className="switch">
                <input type="checkbox" id="addShortageSwitch" />
                <span className="slider"></span>
              </label>
              <p id="addShortageStatus">OFF</p>
            </div>

            {/* Row 5  Col 1*/}
            <div className="Text-column">
              <p>TO CHANGE</p>
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
              <p>TO CHANGE</p>
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
          <DataProvider>
            <RunButton />
            <Chart_Irfs />
          </DataProvider>
        </div>
      </div>
    </>
  );
};

export default Irfs;
