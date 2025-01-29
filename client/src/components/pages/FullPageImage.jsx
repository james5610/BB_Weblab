import React, { useState, useEffect } from "react";
import run_button from "../assets/scratch_texture.png"

const FullPageImage = () => {
  const [opacity, setOpacity] = useState(1); // Initial state for opacity

  useEffect(() => {
    const handleScroll = () => {
      const scrollY = window.scrollY;
      const viewportHeight = window.innerHeight;
      const fadePoint = viewportHeight * 0.8; // Adjust this value for smoothness

      // Calculate opacity based on scroll position
      let newOpacity = 1 - scrollY / fadePoint;
      setOpacity(Math.max(0, newOpacity)); // Ensure it never goes below 0
      console.log(newOpacity)
    };

    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  return (
    <div>
      {/* Full-screen image */}
      <div
        style={{
          position: "relative",
          top: 0,
          left: 0,
          width: "100%",
          height: "100vh",
          backgroundImage: `url(${run_button})`, // Replace with your image
          backgroundSize: "cover",
          backgroundPosition: "center",
          backgroundRepeat: "no-repeat",
          zIndex: 1,
          opacity: opacity, // Change opacity as you scroll
          transition: "opacity 0.2s ease-out", // Smooth fade-out effect
        }}
      ></div>

      {/* Content below the image */}
      <div
        style={{
          position: "relative",
          zIndex: 2,
          backgroundColor: "#fff",
          minHeight: "200vh", // Ensures enough scrollable content
          padding: "20px",
        }}
      >
        <h1>Welcome to My Website</h1>
        <p>Scroll down to see the full-page image fade away!</p>
      </div>
    </div>
  );
};

export default FullPageImage;
