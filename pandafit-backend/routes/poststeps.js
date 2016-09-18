var express = require('express');
var axios = require('axios');
var router = express.Router();

/* GET users listing. */
router.get('/', function(req, res, next) {
	if (req.query.steps) {

		// POST STEPS
		axios.request({
			url: 'http://ec2-52-39-53-104.us-west-2.compute.amazonaws.com/steps/1',
			method: 'post',
			data: {
				numSteps: req.query.steps
			}
		})
		  .then(function (response) {
		    console.log(response);
		    res.send('ok');
		  })
		  .catch(function (error) {
		    console.log(error);
		    console.log(req.query.code);
		    res.send('Error handling code');
		  });

	} else {
		res.send('Error authenticationg');
	}
});

module.exports = router;
