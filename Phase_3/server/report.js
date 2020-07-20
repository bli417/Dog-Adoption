module.exports = {
  animalControl: (req, res, next) => {
    var sql = fs.readFileSync('./sql/report-animal-control.sql').toString();

    db.query(sql, function (err, result) {
      if (err) {
        console.log(err)
        res.status(500).send();

      } else {
        const response = {
          "ac_dog_count": result[0],
          "ac_dog_adopted_gt_60_shelter": result[1],
          "ac_dog_adopted_expense": result[2]
        }
        res.status(200).json(response);
      }
    })
  },
  
  acSurrenderedDogDetail: (req, res, next) => {
    var sql = fs.readFileSync('./sql/report-ac-surrender-dog-detail.sql').toString();

    let selected_month = req.query.month;
    console.log(selected_month)

    db.query(sql, [selected_month], function (err, result) {
      if (err) {
        console.log(err)
        res.status(500).send();

      } else {
        res.status(200).json(result);
      }
    })
  },

  acAdoptedDogDetail: (req, res, next) => {
    var sql = fs.readFileSync('./sql/report-ac-adopted-dog-detail.sql').toString();

    let selected_month = req.query.month;
    console.log(selected_month)

    db.query(sql, [selected_month], function (err, result) {
      if (err) {
        console.log(err)
        res.status(500).send();

      } else {
        res.status(200).json(result);
      }
    })
  }, 

  monthlyAdoption: (req, res, next) => {
    var sql = fs.readFileSync('./sql/report-monthly-adoption.sql').toString();
    
    db.query(sql, function (err, result) {
      if (err) {
        console.log(err)
        res.status(500).send();

      } else {
        res.status(200).json(result);
      }
    })
  },

  volunterLookup: (req, res, next) => {
    var sql = fs.readFileSync('./sql/report-volunteer-lookup.sql').toString();
    let search_text = '%'+req.query.search_text+'%';
    console.log(search_text)
    
    db.query(sql, [search_text, search_text], function (err, result) {
      if (err) {
        console.log(err)
        res.status(500).send();

      } else {
        res.status(200).json(result);
      }
    })
  },

  expenseAnalysis: (req, res, next) => {
    var sql = fs.readFileSync('./sql/report-expense-analysis.sql').toString();
    
    db.query(sql, function (err, result) {
      if (err) {
        console.log(err)
        res.status(500).send();

      } else {
        res.status(200).json(result);
      }
    })
  }
}