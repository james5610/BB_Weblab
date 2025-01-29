import React, { useState, useContext } from "react";
import { DataContext } from "../pages/DataContext";

const RhoShortageSlider = () => {
    const { sharedData, setSharedData } = useContext(DataContext);

  const handleChange = (event) => {
    const newValue = parseFloat(event.target.value);
    setSharedData((prevData) => ({...prevData, rhoShortageSlider: newValue}));
  };

  return (
    <div style={{ width: "200px", margin: "0px auto", textAlign: "center" }}>
      <input
        type="range"
        min="0"
        max="100"
        step = "1"
        value={sharedData.rhoShortageSlider}
        onChange={handleChange}
        style={{ width: "100%" }}
      />
      <p>Persistence: {sharedData.rhoShortageSlider}%</p>
    </div>
  );
};

export default RhoShortageSlider;