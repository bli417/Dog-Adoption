module.exports = {
  // adopters: (req, res) => {
  //   //TODO: return the adopters for autocomplete in applicaton form
  // },
  list: (req, res) => {
    let state = req.query.state || 'pending approval,approved';
    let sql = fs.readFileSync('./sql/application-list.sql').toString();
    let sql_latest = fs.readFileSync('./sql/application-list-latest.sql').toString();
    console.log(sql)
    db.query(
      state=='approved' ? sql_latest:sql,
      [state], function (err, result) {
      if (err) {
        console.log(err)
        res.status(500).send();
      } else {
        res.status(200).send(result);
      }
    }); 
  },

	review: (req, res) => {
    let state =  req.body.state
		let application_number = req.params.application_number;
		var sql = `UPDATE AdoptionApplication SET approval_state=? WHERE application_number=?`;		
		console.log(sql)
		db.query(sql, [state, application_number], function (err, result) {
			if (err) {
        console.log(err);
        res.status(500).send();
			} else {
			  res.status(200).send();
			}
		});	
	},
	create: (req, res) => {
		let adopter = req.body;
		var sql = `SELECT email FROM Adopter WHERE email = '${adopter.email}'`;
		db.query(sql, function (err, result) {
      console.log(err, result);
			if (err) {
        console.log(err);
        res.status(500).send();
      }

      let upsertAdopterPromise = upsert_adopter(req, res, result.length > 0);
      upsertAdopterPromise.then( () => {
        create_application(req, res);
      })
		})
  },

  associate: (req, res) => {
    let app = req.params;
    let sql = fs.readFileSync('./sql/application-associate.sql').toString();
    console.log(app.application_number)
    let query_param = [app.dogID ,app.dogID,req.body.adopted_date,app.application_number];
    db.query(sql,query_param, function (err, result) {
      if (err) {
        console.log(err);
        res.status(500).send();
      } else {
        res.status(200).send(result);
      }
    });	
  },
}

function upsert_adopter(req, res, isUpdate) {
  console.log("insert adopter");
  let application = req.body;
  let sql = isUpdate ? 
    fs.readFileSync('./sql/adopter-update.sql').toString():
    fs.readFileSync('./sql/adopter-add.sql').toString();
  let query_param = [
    application.last_name, application.first_name, application.cell_phone,
    application.street, application.city, application.state, application.zip_code, 
    application.email
  ];
  console.log(sql);
  return new Promise( ( resolve, reject ) => {
    db.query(sql, query_param, function (err, result) {
      if (err) {
        console.log(err)
        res.status(500).send();
        reject();
      }
      resolve();
    });
  });
}

function create_application(req, res) {
  console.log("insert application");
  let application = req.body;
  let sql = fs.readFileSync('./sql/application-add.sql').toString();
  let query_param = [application.apply_date, application.coApp_first_name, application.coApp_last_name, application.email];
  console.log(sql);
  db.query(sql, query_param, function (err, result) {
    if (err) {
      console.log(err)
      res.status(500).send();
    } else {
      res.status(200).send(result);
    }
  });
}