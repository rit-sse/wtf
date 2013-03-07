// This includes all the javascript needed to handle the admin page for events.

//= require templates/other_events.jst.eco
//= require date

$(document).ready(function(){
	getConcurentEvents();
	$(".date-select").change(getConcurentEvents);
});

function getConcurentEvents(){
	var startDate = getStartDate();
	var endDate = getEndDate();

	$("#other-events-error").hide();
	$("#other-events-loading").show();

	$.ajax({
		url: "http://" + window.location.host + "/events.json?start_date=" + 
			startDate + "&end_date=" + endDate
	}).done(function(data){
		console.log(data);
		$("#other_events").html(JST["templates/other_events"]({events :data}));
		$("#other-events-loading").hide();
	}).fail(function(jqXHR, textStatus){
		$("#other-events-loading").hide();
		$("#other-events-error").show();
	});
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

function parseDateTime(datetime){
    retDate = Date.parseExact(datetime, "yyyy-MM-ddTHH:mm:ss-05:00");
    if(!retDate){
      retDate = Date.parseExact(datetime, "yyyy-MM-ddTHH:mm:ss-04:00");
  	}

    if(!retDate){
      console.log("ERROR: no known timezone for server.");
  	}
  
    return retDate;
}