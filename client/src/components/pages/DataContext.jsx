// DataContext.js
import React, { createContext, useState } from "react";

// Create the context
const DataContext = createContext();

// Provide the context
const DataProvider = ({ children }) => {
  const [sharedData, setSharedData] = useState({
    runCount: 0,
    sliderValue: 0,
    grpeSlider: 0,
    grpfSlider: 0,
    vuSlider: 0,
    shortageSlider: 0,
    rhoGrpeSlider: 0,
    rhoGrpfSlider: 0,
    rhoVuSlider: 0,
    rhoShortageSlider: 0,
  }); // Use an object for initial state

  return (
    <DataContext.Provider value={{ sharedData, setSharedData }}>{children}</DataContext.Provider>
  );
};

// Export both the context and provider separately
export { DataContext, DataProvider };
