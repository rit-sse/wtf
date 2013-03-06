$(document).ready(function(){
	getConcurentEvents();
});

function getConcurentEvents(){
	var startDate = getStartDate();
	var endDate = getEndDate();

	$.ajax({
		url: "http://" + window.location.host + "/events.json?start_date=" + 
			startDate + "&end_date=" + endDate
	}).done(function(data){
		console.log(data);
		console.log(JST["templates/other_events"]({events :data}));
		$("#other_events").html(JST["templates/other_events"]({events :data}));
	})
}

function getStartDate(){
	var year = $("#event_start_date_1i")[0].value;
	var month = $("#event_start_date_2i")[0].value;
	var day = $("#event_start_date_3i")[0].value;
	var hour = $("#event_start_date_4i")[0].value;
	var minute = $("#event_start_date_5i")[0].value;

	return "{0}-{1}-{2}T{3}:23:59-05:00".format(year,month,day,hour,minute);
}

function getEndDate(){
	var year = $("#event_end_date_1i")[0].value;
	var month = $("#event_end_date_2i")[0].value;
	var day = $("#event_end_date_3i")[0].value;
	var hour = $("#event_end_date_4i")[0].value;
	var minute = $("#event_end_date_5i")[0].value;

	return "{0}-{1}-{2}T{3}:00:00-05:00".format(year,month,day,hour,minute);	
}