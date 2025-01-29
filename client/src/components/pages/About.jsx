import React, { useContext } from "react";
import "../../utilities.css";
import "./Irfs.css";
import NavBar from "../modules/NavBar";
import "./About.css";

const About = () => {
  return (
    <>
      <NavBar />
      <h2 className="header">About</h2>
      <p className="paragraph">This website was developed for Weblab 2025.</p>

      <p className="paragraph">
        {" "}
        The model featured on this website is known as an impulse response function (IRF).
        Essentially, what this model simulates is how far out of equilibrium some economic variable,
        such as inflation, moves in response to an abnormal shock to the economy. For instance, if
        energy inflation is usually 2% and it suddenly rises to 5% due to external factors, this
        would count as a 3% shock to energy inflation. This model then allows users to see how that
        would affect overall headline inflation and how it would evolve over time. Note that if the
        shock is large and persistent enough, inflation may converge back to a steady state, but at
        a level higher than it once was (e.g. overall inflation might settle at 2.5% rather than
        2%).
      </p>
      <p className="paragraph">
        The code from this model was derived from{" "}
        <a href="https://www.brookings.edu/wp-content/uploads/2023/06/WP86-Bernanke-Blanchard_6.13.pdf">
          Bernanke Blanchard, 2023
        </a>
        . The original code, written in MATLAB, can be found alongside the main paper. While only
        IRFs for headline inflation are included, there are many more models that are utilized that
        can be included in future versions of this website. If you would like to see any models in
        particular, please let me know!
      </p>

      <p className="paragraph">
        The inspiration for this project stemmed from working many years as a research analyst at
        the Federal Reserve and Brookings.There are many people who would benefit from being able to
        run complex economic simulations but are unable to do so. The goal of this project, thus,
        is to provide an easy to use interface that allows everyday individuals to make use of these
        simulations.
      </p>
      <p className="paragraph">
        Special thanks goes out to all who are mentioned in the full paper, Scrollama for providing
        skeleton code for the scrolling instructions, and, of course, the Weblab staff.{" "}
      </p>

      <p className="paragraph">For any questions, please contact James at james56@mit.edu.</p>
    </>
  );
};

export default About;
