const moment = require('moment');
const utility = require('./utility')

module.exports = {
  list: (req, res) => {
    let sql = fs.readFileSync('./sql/dog-list.sql').toString();
    console.log(sql)
    db.query(sql, function (err, result) {
      if (err) {
        console.log(err)
        res.status(500).send();
      } else {
        res.status(200).send(result);
      }
    });
  },
  detail: (req, res) => {
    retrieveDog(req.params.dogID, res);
  },
  update: (req, res) => {
    let dogID = req.params.dogID;
    let dog = req.body;
    let sql = fs.readFileSync('./sql/dog-update.sql').toString();
    let query_param = [dog.name, dog.sex, dog.altered, dog.birth_date,
      dog.description, dog.is_animal_control_surrender, dog.surrender_date,
      dog.surrender_reason, dog.microchipID, dogID, dogID
    ]
    for(let i=0; i<dog.breedIDs.length; i++) {
      let endmark = i == (dog.breedIDs.length - 1) ? ";":",";
      sql += `(?, ?)${endmark}`;
      query_param.push(dogID, dog.breedIDs[i]);
    }
    console.log(sql);
    db.query(sql, query_param, function (err, result) {
      if (err) {
        console.log(err)
        res.status(500).send(err.sqlMessage);
      } else {
        retrieveDog(dogID, res);
      }
    });
  },
  add: (req, res) => {
    let dog = req.body;
    let sql = fs.readFileSync('./sql/dog-add.sql').toString();
    let query_param = [dog.name, dog.sex, dog.altered, dog.birth_date,
      dog.description, dog.is_animal_control_surrender, dog.surrender_date,
      dog.surrender_reason, dog.microchipID, req.user.email
    ];
    console.log(sql)
    db.query(sql, query_param, function (err, result) {
      console.log(result)
      if (err) {
        console.log(err.sqlMessage)
        res.status(500).send(err.sqlMessage);
      } else {
        insertBelong(req, res, result.insertId, dog.breedIDs);
      }
    });
  },
  breeds: (req, res) => {
    var sql = `SELECT breedID, name FROM Breed`;
    console.log(sql)
    db.query(sql, function (err, result) {
      if (err) {
        console.log(err)
        res.status(500).send();
      } else {
        res.status(200).send(result);
      }
    });
  },
  listExpense: (req, res) => {
    let dogID = req.params.dogID;
    let sql = fs.readFileSync('./sql/expense-list.sql').toString();
    console.log(sql)
    db.query(sql, [dogID], function (err, result) {
      if (err) {
        console.log(err)
        res.status(500).send();
      } else {
        res.status(200).send(result);
      }
    });
  },
  addExpense: (req, res) => {
    let dogID = req.params.dogID;
    let expense = req.body;
    let sql = fs.readFileSync('./sql/expense-add.sql').toString();
    let query_param = [dogID, expense.expense_date, expense.vendor, expense.amount, expense.description]
    console.log(sql)
    db.query(sql, query_param, function (err, result) {
      if (err) {
        console.log(err)
        res.status(500).send(err.sqlMessage);
      } else {
        res.status(201).send();
      }
    });
  }
}

function retrieveDog(dogID, res) {
  let sql = fs.readFileSync('./sql/dog-get.sql').toString();
  db.query(sql, [dogID, dogID], function (err, results) {
    if (err) {
      console.log(err)
      res.status(500).send();
    } else {
      let dog = formatDog(results[0][0], results[1])
      res.status(200).send(dog);
    }
  });
}

function insertBelong(req, res, dogID, breedIDs) {
  var sql = `INSERT INTO Belong VALUES`;
  for(let i=0; i<breedIDs.length; i++) {
    let endmark = i == (breedIDs.length - 1) ? ";":",";
    sql += `(${dogID}, ${breedIDs[i]})${endmark}`;
  }
  db.query(sql, function (err, results) {
    if (err) {
      console.log(err)
      res.status(500).send();
    } else {
      retrieveDog(dogID, res);
    }
  });  
}

function formatDog(dog, breed) {
  dog['altered'] = !!dog['altered']
  dog['birth_date'] = moment(dog['birth_date']).format('YYYY-MM-DD')
  dog['surrender_date'] = moment(dog['surrender_date']).format('YYYY-MM-DD')
  dog['is_animal_control_surrender'] = !!dog['is_animal_control_surrender']
  dog['microchipID'] = dog['microchipID'] == "" || dog['microchipID'] == "null" ? null : dog['microchipID']
  dog['breed'] = breed
  return dog;
}