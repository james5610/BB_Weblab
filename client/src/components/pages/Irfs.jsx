import React, { useState, useContext, useEffect, useRef, createContext } from "react";
import { GoogleLogin, googleLogout } from "@react-oauth/google";
import "../../utilities.css";
import "./Irfs.css";
import NavBar from "../modules/NavBar";
import { UserContext } from "../App";
import Chart_Irfs from "./ChartIrfs";
// Create the DataContext for shared state; helps update graph when run button is pressed
import { DataProvider } from "./DataContext";
import { DataContext } from "./DataContext";
import SliderButton from "../modules/SliderButton";
import GrpeSlider from "../modules/GrpeSlider";
import GrpfSlider from "../modules/GrpfSlider";
import VuSlider from "../modules/VuSlider";
import ShortageSlider from "../modules/ShortageSlider";
import RhoGrpeSlider from "../modules/RhoGrpeSlider";
import RhoGrpfSlider from "../modules/RhoGrpfSlider";
import RhoVuSlider from "../modules/RhoVuSlider";
import RhoShortageSlider from "../modules/RhoShortageSlider";

import RunButton from "../modules/RunButton";

const Irfs = () => {
  const { userId, handleLogin, handleLogout } = useContext(UserContext);

  return (
    <>
      <div>
        <NavBar></NavBar>
        {/* <p>Steps to run model</p>
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
        </li> */}
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
        <DataProvider>
          <div className="leftDiv">
            {/* Grid laying out options */}

            <div className="Grid-container">
              {/* Row 1 Col 1 */}
              <div className="Text-column">
                <p>Energy Inflation Shock</p>
              </div>

              {/* Row 1 Col 2 */}
              <GrpeSlider />

              {/* Row 2 Col 1*/}
              <div className="Text-column">
                <p>Food Inflation Shock</p>
              </div>

              {/* Row 2 Col 2 */}
              <GrpfSlider />

              {/* Row 3  Col 1*/}
              <div className="Text-column">
                <p>Labor Market Shock</p>
              </div>

              {/* Row 3 Col 2 */}
              <VuSlider />

              {/* Row 4  Col 1*/}
              <div className="Text-column">
                <p>Shortage Shock</p>
              </div>

              {/* Row 4 Col 2 */}
              <ShortageSlider />

              {/* Row 5  Col 1*/}
              <div className="Text-column">
                <p>Energy Inflation Shock Persistence</p>
              </div>

              {/* Row 5 Col 2 */}
              <RhoGrpeSlider />

              {/* Row 6  Col 1*/}
              <div className="Text-column">
                <p>Food Inflation Shock Persistence</p>
              </div>

              {/* Row 6 Col 2 */}
              <RhoGrpfSlider />

              {/* Row 7  Col 1*/}
              <div className="Text-column">
                <p>Labor Market Shock Persistence</p>
              </div>

              {/* Row 7 Col 2 */}
              <RhoVuSlider />

              {/* Row 8  Col 1*/}
              <div className="Text-column">
                <p>Shortage Shock Persistence</p>
              </div>

              {/* Row 8 Col 2 */}
              <RhoShortageSlider />
            </div>
          </div>
          <div className="rightDiv">
            {/* Graph Staging Grounds */}
            <RunButton />
            <Chart_Irfs />
          </div>
        </DataProvider>
      </div>
    </>
  );
};

export default Irfs;
