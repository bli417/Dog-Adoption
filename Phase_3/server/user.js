const jwt = require('jsonwebtoken');
const md5 = require('blueimp-md5');
const JWT_SECRET = process.env.JWT_SECRET
const TOKEN_LIFE = process.env.TOKEN_LIFE

module.exports = {
  login: (req, res) => {
    const postData = req.body;
    var sql = `SELECT email, password, is_admin FROM User WHERE email = '${postData.email}'`;
    db.query(sql, function (err, result) {
      if (err) {
        console.log(err)
        res.status(500).send();
      } else if (result.length == 0 || result[0].password != md5(postData.password)) {
        res.status(401).send('Incorrect credential');
      } else {
        const user = {
          "email": result[0].email,
          "is_admin": result[0].is_admin
        }
        const token = jwt.sign(user, JWT_SECRET, { expiresIn: TOKEN_LIFE })
        res.status(200).json({ "token": token });
      }
    });
  },
  me: (req, res) => {
    var sql = `SELECT * FROM User WHERE email = '${req.user.email}'`;
    db.query(sql, function (err, result) {
      if (err) {
        console.log(err)
        res.status(500).send();
      } else if (result.length == 0) {
        res.status(401).send('Incorrect credential');
      } else {
        const response = {
          "email": result[0].email,
          "first_name": result[0].first_name,
          "last_name": result[0].last_name,
          "cell_phone": result[0].cell_phone,
          "started_date": result[0].started_date,
          "is_admin": !!result[0].is_admin
        }
        res.status(200).json(response);
      }
    })
  },
  checkToken: (req, res, next) => {
    const token = req.headers['x-access-token']
    // decode token
    if (token) {
      // verifies secret and checks exp
      jwt.verify(token, JWT_SECRET, function (err, user) {
        if (err) {
          return res.status(401).json({
            "error": true,
            "message": 'Unauthorized access.'
          });
        }
        req.user = user;
        next();
      });
    } else {
      return res.status(403).send({
        "error": true,
        "message": 'No token provided.'
      });
    }
  },
  checkAdminToken: (req, res, next) => {
    const token = req.headers['x-access-token']
    // decode token
    if (token) {
      // verifies secret and checks exp
      jwt.verify(token, JWT_SECRET, function (err, user) {
        if (err || !user.is_admin) {
          return res.status(401).json({
            "error": true,
            "message": 'Unauthorized access.'
          });
        }
        req.user = user;
        next();
      });
    } else {
      return res.status(403).send({
        "error": true,
        "message": 'No token provided.'
      });
    }
  }
}