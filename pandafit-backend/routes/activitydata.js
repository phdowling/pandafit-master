var express = require('express');
var axios = require('axios');
var router = express.Router();

/* GET users listing. */
router.get('/', function(req, res, next) {
			console.log(req);
			res.send('s');

	// if (req.query.code) {
	// 	console.log(req);
	// 	res.send(req.query.code);
	// } else {
	// 	res.send('Error authenticationg');
	// }
});

module.exports = router;
