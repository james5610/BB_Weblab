import { DataContext } from "../pages/DataContext";
import React, { useContext } from "react";
import { get, post } from "../../utilities";
const run_irfs = async (sharedData, setSharedData) => {

    // const { setSharedData } = useContext(DataContext);

    let params = {
      // addGrpeSwitch: addGrpeSwitch.checked,
      grpeSlider: sharedData.grpeSlider,
      grpfSlider: sharedData.grpfSlider,
      vuSlider: sharedData.vuSlider,
      shortageSlider: sharedData.shortageSlider,
      rhoGrpeSlider: sharedData.rhoGrpeSlider,
      rhoGrpfSlider: sharedData.rhoGrpfSlider,
      rhoVuSlider: sharedData.rhoVuSlider,
      rhoShortageSlider: sharedData.rhoShortageSlider 
    };
    
    await get("/api/run_irfs", params).then((results) => {
    //   console.log(`Results under line 26 Test1.jsx: ${JSON.stringify(results)}`);
      // console.log(`Params prior to running: ${sharedData}`)
    //   console.log({ results });
    });
    let response = await get("./api/update_irf_data");
    console.log(`Response is ${JSON.stringify(response)}`);
    setSharedData((prevData) => ({ ...prevData, ...response }));
    // setSharedData((prevData) => ({...prevData, "Test Value": [1,2,3]}));
    // await setSharedData(response);
    // setSharedData((prevData) => ({...prevData, ["Test Data"]: [1,2,3]}))
    // console.log(`Response 2 is ${JSON.stringify(response)}`);
  };

// For Updating Graph whenever run button is pressed
const RunButton = () => {
  const { sharedData, setSharedData } = useContext(DataContext);

  const handleRun = async () => {
    await run_irfs(sharedData, setSharedData);
    setSharedData((prevData) => ({ ...prevData, runCount: sharedData.runCount + 1}));
    // console.log(sharedData.runCount) // we use this variable to control when the chart actually updates; otherwise, it updates anytime any value in sharedData updates
  };

  return <button onClick={handleRun}>Update Graph</button>;
};

export default RunButton;
