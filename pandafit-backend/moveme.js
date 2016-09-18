var axios = require('axios');
var querystring = require('querystring');

var scope_vars = ['activity'];

// axios.get('https://www.fitbit.com/oauth2/authorize', {
// 	params: {
// 		response_type: 'code',
// 		client_id: '227Z6Z',
// 		redirect_uri: 'https://5673f765.ngrok.io',
// 		scope: scope_vars.join(' ')
// 	}
// })


// GET AUTHORIZATION
// axios.request({
// 	url: 'https://api.fitbit.com/oauth2/token',
// 	method: 'post',
// 	headers: {
// 		'Authorization': 'Basic MjI3WjZaOjU2NzZlZTFiMjJkOTA3Zjc5ZmI2OGQwYjY0NjIyZDNi=',
// 		'Content-Type': 'application/x-www-form-urlencoded'
// 	},
// 	params: {
// 		code: '06884212086111f6463efd5bd6a61e1b0e2a1d68',
// 		grant_type: 'authorization_code',
// 		client_id: '227Z6Z',
// 		redirect_uri: 'https://5673f765.ngrok.io'
// 	}
// })
//   .then(function (response) {
//     console.log(response.data);
//   })
//   .catch(function (error) {
//     console.log(error);
//   });

// function getDateParameter() {
// 	var today = new Date();
// 	var dd = today.getDate();
// 	var mm = today.getMonth()+1; 

// 	var yyyy = today.getFullYear();
// 	if(dd<10){
// 	    dd='0'+dd
// 	} 
// 	if(mm<10){
// 	    mm='0'+mm
// 	} 

// 	return yyyy+'-'+mm+'-'+dd;
// }

// // GET DATA
// axios.request({
// 	url: 'https://api.fitbit.com/1/user/4XTL4C/activities/date/'+getDateParameter()+'.json',
// 	method: 'get',
// 	headers: {
// 		'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0WFRMNEMiLCJhdWQiOiIyMjdaNloiLCJpc3MiOiJGaXRiaXQiLCJ0eXAiOiJhY2Nlc3NfdG9rZW4iLCJzY29wZXMiOiJyYWN0IiwiZXhwIjoxNDc0MTAzNzYyLCJpYXQiOjE0NzQwNzQ5NjJ9.aQSbhtFeFOjfPgjlIpcmpEDgS9QWIKhky-OApz1014Q',
// 		'Content-Type': 'application/x-www-form-urlencoded'
// 	}
// })
//   .then(function (response) {
//     console.log(response.data.summary.steps);
//   })
//   .catch(function (error) {
//     console.log(error);
//   });
