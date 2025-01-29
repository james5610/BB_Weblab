/*
|--------------------------------------------------------------------------
| api.js -- server routes
|--------------------------------------------------------------------------
|
| This file defines the routes for your server.
|
Create new endpoint (runsimulation)

*/

const express = require("express");

// import models so we can interact with the database
const User = require("./models/user");

// import authentication library
const auth = require("./auth");

// api endpoints: all these paths will be prefixed with "/api/"
const router = express.Router();

//initialize socket
const socketManager = require("./server-socket");

router.post("/login", auth.login);
router.post("/logout", auth.logout);
router.get("/whoami", (req, res) => {
  if (!req.user) {
    // not logged in
    return res.send({});
  }

  res.send(req.user);
});

router.post("/initsocket", (req, res) => {
  // do nothing if user not logged in
  if (req.user)
    socketManager.addUser(req.user, socketManager.getSocketFromSocketID(req.body.socketid));
  res.send({});
});

// |------------------------------|
// | write your API methods below!|
// |------------------------------|
const run_irfs = require("./run_irfs.jsx");

router.get("/run_irfs", async (req, res) => {
  const results = await run_irfs.run_irfs(
    req.query.grpeSlider,
    req.query.grpfSlider,
    req.query.vuSlider,
    req.query.shortageSlider,
    req.query.rhoGrpeSlider,
    req.query.rhoGrpfSlider,
    req.query.rhoVuSlider,
    req.query.rhoShortageSlider
  );
  res.send(results);
});

const update_irf_data = require("./update_irf_data.jsx");

router.get("/update_irf_data", async (req, res) => {
  const data = await update_irf_data.update_irf_data();
  res.send(data);
});

// const run_econ_model = require("./run_econ_model.jsx");

// router.get("/run_econ_model", async (req, res) => {
//   const results = await run_econ_model.run_econ_model(req.query.addResidualsSwitch,
//       req.query.removeGrpeSwitch, req.query.removeGrpfSwitch, req.query.removeVuSwitch,
//       req.query.removeShortageSwitch);
//   res.send(results);
// });

const update_dynamic_simul_data = require("./update_dynamic_simul_data.jsx");

router.get("/update_dynamic_simul_data", async (req, res) => {
  const data = await update_dynamic_simul_data.update_dynamic_simul_data();
  res.send(data);
});

// anything else falls to this "not found" case
router.all("*", (req, res) => {
  console.log(`API route not found: ${req.method} ${req.url}`);
  res.status(404).send({ msg: "API route not found" });
});

module.exports = router;
