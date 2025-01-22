// DataContext.js
import React, { createContext, useState } from "react";

// Create the context
const DataContext = createContext();

// Provide the context
const DataProvider = ({ children }) => {
  const [sharedData, setSharedData] = useState({}); // Use an object for initial state

  return (
    <DataContext.Provider value={{ sharedData, setSharedData }}>
      {children}
    </DataContext.Provider>
  );
};

// Export both the context and provider separately
export { DataContext, DataProvider };