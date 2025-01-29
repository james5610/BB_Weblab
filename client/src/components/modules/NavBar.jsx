import React from "react";
import { Link } from "react-router-dom";

import "./NavBar.css";

/**
 * The navigation bar at the top of all pages. Takes no props.
 */
const NavBar = () => {
  return (
    <nav className="NavBar-container">
      <div className="NavBar-title u-inlineBlock">BB Interactive IRFs</div>
      <div className="NavBar-linkContainer u-inlineBlock">
        <Link to="/" className="NavBar-link">
          Home
        </Link>
        <Link to="/About/" className="NavBar-link">
          About
        </Link>
      </div>
    </nav>
  );
};

export default NavBar;
