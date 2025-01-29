import React, { useState, useEffect, useRef, useContext } from "react";
import { Chart, LineController, LineElement, PointElement, LinearScale, Title, CategoryScale, Tooltip } from 'chart.js';
// import { get, post } from "../../utilities";
import { DataContext } from "./DataContext"; // Import the shared context

const ChartIrfs = () => {
  const chartRef = useRef(null); // Create a reference to the canvas element
  const { sharedData } = useContext(DataContext); // Access shared data

  // // Register the required Chart.js components
  Chart.register(LineController, LineElement, PointElement, LinearScale, Title, CategoryScale, Tooltip);

  useEffect(() => {
    if (sharedData && Object.keys(sharedData).length > 0) {
      // Labels for the x-axis (categories)
      const labels = sharedData.Period;

      // Prepare datasets
      const datasets = [
        {
          label: "GCPI",
          data: sharedData.gcpi_simul, // Third array
          borderColor: 'rgb(128, 0, 0)', // Line color
          backgroundColor: "rgb(128, 0, 0)",
        },
      ];

      // Create the chart
      const ctx = chartRef.current.getContext("2d");
      const myChart = new Chart(ctx, {
        type: "line",
        data: {
          labels: labels,
          datasets: datasets,
        },
        options: {
          responsive: true,
          plugins: {
            legend: {
              display: false,
              position: "top",
            },
            tooltip: {
              enabled: true, // Ensure tooltips are enabled (default: true)
              mode: "nearest", // Tooltip mode: show the closest data point
              intersect: false, // Show tooltip even if not directly over the point
              callbacks: {
                // Customize tooltip content (optional)
                label: function (tooltipItem) {
                  return `Value: ${tooltipItem.raw}`; // Display the value of the data point
                },
              },
            },
          },
          scales: {

            x: {
              type: "category", // Use "category" scale for x-axis
              title: {
                display: true,
                text: "Period",
                font: {
                  size: 16,
                },
                color: "black",
              },
              
              ticks: {
                color: "black", // Change x-axis label color
              },
              grid: {
                color: "rgba(0, 0, 0, 1)",
                display: false,
              },
              border: {
                color: "black", // X-axis line color
              },
              
            },
            y: {
              type: "linear", // Use "linear" scale for y-axis
              beginAtZero: false,
              title: {
                display: true,
                text: "Percent",
                font: {
                  size: 16,
                },
                color: "black",
              },
              grid: {
                color: "rgba(0, 0, 0, 1)",
                display: false,
              },
              ticks: {
                color: "black", // Change x-axis label color
              },
              border: {
                color: "black", // X-axis line color
              },
            },
          },
        },
      });

      // Cleanup function to destroy the chart on component unmount
      return () => {
        myChart.destroy();
      };
    }
  }, [sharedData.runCount]); // Run this effect whenever "data" changes

  return <canvas ref={chartRef} />;
};

export default ChartIrfs;
