const mysql = require('mysql');
const bodyParser = require("body-parser");
const express = require("express");
const router = express.Router();
const morgan = require('morgan');
const cors = require('cors');
const fs = require("fs");

const user = require('./user');
const dog = require('./dog');
const report = require('./report');
const application = require('./application');


connection = mysql.createConnection({
  host: "db",
  user: "team012",
  password: "cs6400",
  database: "MuttHouse",
  multipleStatements: true
});
connection.connect();
global.db = connection;
global.fs = fs;

const app = express();
app.use(bodyParser.json());
app.use(morgan('combined'));
app.use(cors());

//anonymous
router.post('/v1/login', user.login);

//user restricted
router.use(user.checkToken);
router.get("/v1/user/me", user.me);
router.get("/v1/dogs", dog.list);
router.get("/v1/dogs/breeds", dog.breeds);
router.get("/v1/dogs/:dogID", dog.detail);
router.put("/v1/dogs/:dogID", dog.update);
router.post("/v1/dogs", dog.add);
router.get("/v1/dogs/:dogID/expense", dog.listExpense);
router.post("/v1/dogs/:dogID/expense", dog.addExpense);
router.get("/v1/applications", application.list);
router.post("/v1/applications", application.create);
//router.get("/v1/adopters", application.adopters) //for optional feature, autocomplete adopters

//admin restricted
router.use(user.checkAdminToken);
router.get("/v1/report/animal_control", report.animalControl);
router.put("/v1/applications/:application_number", application.review);
router.put("/v1/applications/:application_number/associate/:dogID", application.associate);
router.get("/v1/applications/:application_number/associate/:dogID", application.associate);
router.get("/v1/report/animal_control/surrendered", report.acSurrenderedDogDetail);
router.get("/v1/report/animal_control/adopted", report.acAdoptedDogDetail);
router.get("/v1/report/monthly_adoption", report.monthlyAdoption);
router.get("/v1/report/volunteer_lookup", report.volunterLookup);
router.get("/v1/report/expense_analysis", report.expenseAnalysis);

app.use('/api', router)

var server = app.listen(process.env.PORT || 3000, function () {
  var port = server.address().port;
  console.log("MuttHouse listening on port", port);
});
