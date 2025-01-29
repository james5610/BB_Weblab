import React, { useState, useContext } from "react";
import { DataContext } from "../pages/DataContext";

const RhoVuSlider = () => {
    const { sharedData, setSharedData } = useContext(DataContext);

  const handleChange = (event) => {
    const newValue = parseFloat(event.target.value);
    setSharedData((prevData) => ({...prevData, rhoVuSlider: newValue}));
  };

  return (
    <div style={{ width: "200px", margin: "0px auto", textAlign: "center" }}>
      <input
        type="range"
        min="0"
        max="100"
        step = "1"
        value={sharedData.rhoVuSlider}
        onChange={handleChange}
        style={{ width: "100%" }}
      />
      <p>Persistence: {sharedData.rhoVuSlider}%</p>
    </div>
  );
};

export default RhoVuSlider;