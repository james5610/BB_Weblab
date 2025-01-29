import React, {useContext} from "react";
import "../../utilities.css";
import "./Irfs.css";
import NavBar from "../modules/NavBar";
import { UserContext } from "../App";
import Chart_Irfs from "./ChartIrfs";
// Create the DataContext for shared state; helps update graph when run button is pressed
import { DataProvider } from "./DataContext";
import GrpeSlider from "../modules/GrpeSlider";
import GrpfSlider from "../modules/GrpfSlider";
import VuSlider from "../modules/VuSlider";
import ShortageSlider from "../modules/ShortageSlider";
import RhoGrpeSlider from "../modules/RhoGrpeSlider";
import RhoGrpfSlider from "../modules/RhoGrpfSlider";
import RhoVuSlider from "../modules/RhoVuSlider";
import RhoShortageSlider from "../modules/RhoShortageSlider";
import RunButton from "../modules/RunButton";
import StoryTellingComponent from "./StoryTellingComponent";

const Irfs = () => {
  return (
    <>
      <div>
        <NavBar></NavBar>
      </div>
      <div>
        <StoryTellingComponent />
      </div>
      <div>
        <NavBar></NavBar>
      </div>
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
            <Chart_Irfs />
            <p></p>
            <RunButton />
            
          </div>
        </DataProvider>
      </div>
    </>
  );
};

export default Irfs;
