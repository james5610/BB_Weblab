import React, { useState, useEffect, useRef } from "react";
import {
  Chart,
  BarController,
  BarElement,
  CategoryScale,
  LinearScale,
  Title,
  Tooltip,
  Legend,
} from "chart.js";
import { get, post } from "../../utilities";

const StackedBarChart = () => {
  const chartRef = useRef(null); // Create a reference to the canvas element
  const [data, setData] = useState([]); // State to store function result

  // Register the required Chart.js components
  Chart.register(BarController, BarElement, CategoryScale, LinearScale, Title, Tooltip, Legend);

  //   Define fetchData
  const fetchData = async () => {
    try {
      let response = await get("./api/update_data");
      return response;
    } catch (error) {
      console.error("Error fetching data in StackedBarChart:", error);
      return [];
    }
  };

  //   useEffect for loading data
  useEffect(() => {
    const load_data = async () => {
      const response = await fetchData();
      setData(response);
    };
    load_data();
  }, []);

  //   Check if data loaded
  useEffect(() => {
    if (data && Object.keys(data).length > 0) {
      console.log(data);

      // Labels for the x-axis (categories)
      //   const labels = data.Dates.slice(1, 4);
      const labels = data.Dates;

      // Prepare datasets
      const datasets = [
        // {
        //   label: "Variable 1",
        //   data: data.grpe_simul.slice(0, 3), // First array
        //   backgroundColor: "rgba(255, 99, 132, 0.5)", // Color with transparency
        // },
        // {
        //   label: "Variable 2",
        //   data: data.gw_simul.slice(0, 3), // Second array
        //   backgroundColor: "rgba(54, 162, 235, 0.5)",
        // },
        {
          label: "GCPI",
          data: data.gcpi_simul, // Third array
          backgroundColor: "rgba(75, 192, 192, 0.5)",
        },
        // {
        //   label: "Variable 4",
        //   data: data.diffcpicf_simul.slice(0, 3), // Third array
        //   backgroundColor: "rgba(75, 192, 192, 0.5)",
        // },
        // {
        //   label: "Variable 5",
        //   data: data.cf10_simul.slice(0, 3), // Third array
        //   backgroundColor: "rgba(75, 192, 192, 0.5)",
        // },
        // {
        //   label: "Variable 6",
        //   data: data.cf1_simul.slice(0, 3), // Third array
        //   backgroundColor: "rgba(75, 192, 192, 0.5)",
        // },
      ];

      // Create the chart
      const ctx = chartRef.current.getContext("2d");
      const myChart = new Chart(ctx, {
        type: "bar",
        data: {
          labels: labels,
          datasets: datasets,
        },
        options: {
          responsive: true,
          plugins: {
            legend: {
              position: "top",
            },
          },
          scales: {
            x: {
              stacked: true, // Stack bars on the x-axis
            },
            y: {
              stacked: true, // Stack bars on the y-axis
            },
          },
        },
      });

      // Cleanup function to destroy the chart on component unmount
      return () => {
        myChart.destroy();
      };
    }
  }, [data]); // Run this effect whenever "data" changes

  return <canvas ref={chartRef} />;
};

export default StackedBarChart;
