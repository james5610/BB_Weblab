import React, { useState, useContext } from "react";
import { DataContext } from "../pages/DataContext";

const GrpeSlider = () => {
    const { sharedData, setSharedData } = useContext(DataContext);

  const handleChange = (event) => {
    const newValue = parseFloat(event.target.value);
    setSharedData((prevData) => ({...prevData, grpeSlider: newValue}));
  };

  return (
    <div style={{ width: "200px", margin: "0px auto", textAlign: "center" }}>
      <input
        type="range"
        min="0"
        max="3"
        step = "0.1"
        value={sharedData.grpeSlider}
        onChange={handleChange}
        style={{ width: "100%" }}
      />
      <p>Standard Deviations: {sharedData.grpeSlider}</p>
    </div>
  );
};

export default GrpeSlider;