import React, { useState, useContext, useEffect, useRef, createContext } from "react";
import { GoogleLogin, googleLogout } from "@react-oauth/google";
import "../../utilities.css";
import "./Test1.css";
import { get, post } from "../../utilities";
import { UserContext } from "../App";
import StackedBarChart from "./StackedBarChart";
// Create the DataContext for shared state; helps update graph when run button is pressed
import { DataProvider } from "./DataContext";
import { DataContext } from "./DataContext";

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
    };

    get("/api/run_econ_model", params).then((results) => {
        console.log(`Results under line 26 Test1.jsx: ${JSON.stringify(results)}`);
    });
  };

  const update_data = () => {
    get("/api/update_data").then((data) => {
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

  // For Updating Graph whenever run button is pressed
  // const [sharedData, setSharedData] = useState([]); // Shared state for chart data
  // "Run" button component
  const RunButton = () => {
    const { setSharedData } = useContext(DataContext);

    const handleRun = async () => {
      try {
        // Define fetchData
        const fetchData = async () => {
          try {
            let response = await get("./api/update_data");
            return response;
          } catch (error) {
            console.error("Error fetching data in StackedBarChart:", error);
            return [];
          }
        };

        const response = await fetchData();
        console.log(response);
        setSharedData(response); // Update the shared data
        // console.log(response);
        // console.log(sharedData);
      } catch (error) {
        console.error("Error updating data:", error);
      }
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
  <li>Note that the RUN button and then the Update Graph button must be pressed in that order each time the graph wants to be updated</li>
  <li>Also note that because of the way we initialize our equations, the first four data points will always be the same</li>
  <li>This model shows GCPI, or CPI inflation and how it is affected by the variou toggles. In the future, additional variables will be available, as well as a way to see the contribution of each toggle to headline numbers.</li>
  <li>You can view various messages and checks in the console. In the future, these will be removed.</li>
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


      {/* Run model*/}
      <div
        className="Run-buttonContainer"
        onClick={() => {
          run_econ_model();
          update_data();
          // console.log(`From Run button:`)
          // console.log(sharedData)
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
          <DataProvider>
            <RunButton />
            <StackedBarChart />
          </DataProvider>
        </div>
      </div>
    </>
  );
};

export default Skeleton;
