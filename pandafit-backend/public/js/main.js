function getDateParameter() {
	var today = new Date();
	var dd = today.getDate();
	var mm = today.getMonth()+1; 

	var yyyy = today.getFullYear();

	if(dd<10){
	    dd='0'+dd
	} 
	if(mm<10){
	    mm='0'+mm
	} 

	return yyyy+'-'+mm+'-'+dd;
}

var lastValue = 9333,
	incrementalSteps = 0;

function getSteps(steps_counter, url, auth) {
	$.ajax(url, {
    	headers: {
			'Authorization': auth,
			'Content-Type': 'application/x-www-form-urlencoded'
		},
		success: function(response){
			steps_counter.html(response.summary.steps);

			if (lastValue) {
				incrementalSteps = response.summary.steps - lastValue;
			}

			if (incrementalSteps > 0) {
				// send steps to server
				$.get('https://76798aa7.ngrok.io/poststeps', {steps: incrementalSteps}, function(){

				});
			} else {
				incrementalSteps = 0;
			}

			lastValue = response.summary.steps;

			console.log('lastValue: ', lastValue);
			console.log('incrementalSteps: ', incrementalSteps);

			setTimeout(function(){
				getSteps(steps_counter, url, auth);
			}, 1000*30);
		},
		error: function() {
			console.log('Error getting steps');
		}
    });
}

$( document ).ready(function($) {

	var steps_counter = $('#steps-counter'),
		url = 'https://api.fitbit.com/1/user/'+steps_counter.data('userid')+'/activities/date/'+getDateParameter()+'.json',
		auth = 'Bearer '+steps_counter.data('token');

	getSteps(steps_counter, url, auth);
});