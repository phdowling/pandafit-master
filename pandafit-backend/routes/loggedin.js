var express = require('express');
var axios = require('axios');
var router = express.Router();

/* GET users listing. */
router.get('/', function(req, res, next) {
	if (req.query.code) {

		// GET AUTHORIZATION
		axios.request({
			url: 'https://api.fitbit.com/oauth2/token',
			method: 'post',
			headers: {
				'Authorization': 'Basic MjI3WjZaOjU2NzZlZTFiMjJkOTA3Zjc5ZmI2OGQwYjY0NjIyZDNi=',
				'Content-Type': 'application/x-www-form-urlencoded'
			},
			params: {
				code: req.query.code,
				grant_type: 'authorization_code',
				client_id: '227Z6Z',
				redirect_uri: 'https://76798aa7.ngrok.io/loggedin'
			}
		})
		  .then(function (response) {
		  	// console.log(req);
		    console.log(response.data);

		    if (response.data.access_token) {

		    	res.render('activity', {userid: response.data.user_id, token: response.data.access_token});

		    	// res.send('s');

				// GET DATA
				// axios.request({
				// 	url: 'https://api.fitbit.com/1/user/'+response.data.user_id+'/activities/date/'+getDateParameter()+'.json',
				// 	method: 'get',
				// 	headers: {
				// 		'Authorization': 'Bearer '+response.data.access_token,
				// 		'Content-Type': 'application/x-www-form-urlencoded'
				// 	}
				// })
				//   .then(function (response) {
				//     // console.log(response.data.summary.steps);
				//     res.send(response.data.summary.steps.toString());
				//     // res.send('x');
				//   })
				//   .catch(function (error) {
				//     console.log(error);
				//     res.send('Error getting activity data');
				//   });

		    }

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
