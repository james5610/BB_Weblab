import React, { useState, useContext } from "react";
import { DataContext } from "../pages/DataContext";

const SliderButton = () => {
    const { sharedData, setSharedData } = useContext(DataContext);

  const handleChange = (event) => {
    const newValue = parseFloat(event.target.value);
    setSharedData((prevData) => ({...prevData, sliderValue: newValue}));
  };

  return (
    <div style={{ width: "200px", margin: "0px auto", textAlign: "center" }}>
      <input
        type="range"
        min="0"
        max="3"
        step = "0.1"
        value={sharedData.sliderValue}
        onChange={handleChange}
        style={{ width: "100%" }}
      />
      <p>Value: {sharedData.sliderValue}</p>
    </div>
  );
};

export default SliderButton;