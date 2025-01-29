import React, { PureComponent } from "react";
import injectSheet from "react-jss";
import { Scrollama, Step } from "react-scrollama";
import shockSliders from "../assets/shock_sliders.png";
import persistenceSliders from "../assets/persistence_sliders.png";
import graphExample from "../assets/graphExample.png";

const styles = {
  navbar: {
    position: "fixed",
    display: "flex",
    top: 0,
    right: 0,
    zIndex: 1,
    "& a": {
      display: "block",
      fontSize: "20px",
      padding: "20px",
    },
  },
  pageTitle: {
    textAlign: "center",
    fontSize: 22,
    margin: "90px 0 10px",
    visibility: "hidden",
  },
  description: {
    textAlign: "center",
    maxWidth: 800,
    margin: "70px auto 30px",
    fontSize: 22,
    lineHeight: "28px",
    "& a": {
      color: "black",
    },
  },
  pageSubtitle: {
    textAlign: "center",
    fontSize: 22,
    color: "#888",
  },
  graphicContainer: {
    padding: "15vh 2vw 20vh",
    display: "flex",
    justifyContent: "space-between",
  },
  graphic: {
    flexBasis: "60%",
    position: "sticky",
    width: "90%",
    height: "60%",
    top: "10vh",
    backgroundColor: "white",
    display: "flex",
    alignItems: "center",
    justifyContent: "left",
    "& p": {
      fontSize: "5rem",
      fontWeight: 700,
      textAlign: "center",
      color: "#fff",
    },
  },
  scroller: {
    flexBasis: "35%",
  },
  step: {
    width: "300px",
    margin: "0 auto 3rem auto",
    padding: "150px 0",
    border: "1px solid #333",
    "& p": {
      textAlign: "center",
      padding: "1rem",
      fontSize: "1.2rem",
      margin: 0,
    },
    "&:last-child": {
      marginBottom: 0,
    },
  },
  button: {
    backgroundColor: "rgb(32, 58, 108)",
    color: "white",
    borderRadius: "4px",
    cursor: "pointer",
    padding: "6px",
    textAlign: "center",
    display: "block",
    maxWidth: 220,
    margin: "10px auto 30px",
    fontSize: 19,
    lineHeight: "28px",
    textDecoration: "none",
  },
  subhed: {
    maxWidth: 600,
    margin: "10px auto 15px",
    fontSize: 22,
    lineHeight: "28px",
    "& a": {
      color: "black",
    },
    textAlign: "center",
  },
  whoUsing: {
    maxWidth: 960,
    margin: "30px auto 100px",
    fontSize: 19,
    lineHeight: "26px",
    gridAutoRows: "minmax(100px, auto)",
    "& a": {
      color: "black",
    },
    "& img": {
      width: "100%",
    },
    display: "grid",
    gridTemplateColumns: "2fr 5fr",
    "& > div": {
      padding: "16px 0",
      borderTop: "1px solid #ccc",
      "&:nth-child(odd)": {
        paddingRight: "13px",
        borderRight: "1px solid #ccc",
      },
      "&:nth-child(even)": {
        paddingLeft: "13px",
      },
    },
  },
};

class StoryTellingComponent extends PureComponent {
  state = {
    data: 0,
    steps: [
      {
        Text: "Step 1: The first step to running the model is to set how large the shock is. For instance, if the price of gas were to suddenly increase, this would be a shock to the price of energy. This model allows you to choose by how many standard deviations, relative to historic data, to set the shock to.",
        Image: shockSliders,
      },
      {
        Text: "Step 2: We now need to set how persistent the shock is. For instance, if we set the initial shock to energy inflation at 1.0 standard deviations and assume 90% persistency, then the next period would have a 0.81 standard deviation shock, followed by a 0.73 standard deviation shock and so on. Persistency of 0% indicates a one-time shock, and persistency of 100% indicates the shock is applied in perpetuity.",
        Image: persistenceSliders,
      },
      {
        Text: "Step 3: All that's left to do is run the model. You can freely change parameters, though it will likely be most useful to introduce one shock at a time. You can scroll over data points in the graph to see what value at various times are. Good luck!",
        Image: graphExample,
      },
    ],
    progress: 0,
  };

  onStepEnter = (e) => {
    const { data, entry, direction } = e;
    this.setState({ data });
  };

  onStepExit = ({ direction, data }) => {
    if (direction === "up" && data === this.state.steps[0]) {
      this.setState({ data: 0 });
    }
  };

  onStepProgress = ({ progress }) => {
    this.setState({ progress });
  };

  render() {
    const { data, steps, progress } = this.state;
    const { classes } = this.props;

    return (
      <div>
        <p className={classes.description}>
          This website provides a usable interface for running impulse response functions (IRFS),
          based off a model featured in{" "}
          <a href="https://www.brookings.edu/wp-content/uploads/2023/06/WP86-Bernanke-Blanchard_6.13.pdf">
            Bernanke Blanchard 2023.
          </a>
        </p>

        <a
          className={classes.button}
          href="https://www.brookings.edu/wp-content/uploads/2023/06/WP86-Bernanke-Blanchard_6.13.pdf"
        >
          View full paper here
        </a>

        <p className={classes.pageSubtitle}>Scroll ↓</p>
        <div className={classes.graphicContainer}>
          <div className={classes.scroller}>
            <Scrollama
              onStepEnter={this.onStepEnter}
              onStepExit={this.onStepExit}
              onStepProgress={this.onStepProgress}
              offset="600px"
            >
              {steps.map((value, index) => {
                const isVisible = value === data;
                const background = isVisible ? `rgba(44,127,184, ${progress})` : "white";
                const visibility = isVisible ? "visible" : "hidden";
                return (
                  <Step data={value} key={index}>
                    <div className={classes.step} style={{ background }}>
                      <p>{value.Text}</p>
                    </div>
                  </Step>
                );
              })}
            </Scrollama>
          </div>
          <div className={classes.graphic}>
            <img className={classes.graphic} src={data.Image} />
          </div>
        </div>
      </div>
    );
  }
}

export default injectSheet(styles)(StoryTellingComponent);
