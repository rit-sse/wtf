// This includes all the javascript needed to handle the admin page for events.

//= require templates/other_events.jst.eco
//= require date

$(document).ready(function(){
	start_date = $("#event_start_date").val();
	end_date = $("#event_end_date").val();

	$("#event_start_date").val("");
	$("#event_end_date").val("");
	console.log(start_date);

	if(start_date == ""){
		start_date = Date.now().set({minute: 0, second:0});
	}
	else{
		start_date = Date.parse(start_date.replace(".000000", "")).setTimezoneOffset(0);
		console.log(start_date);
	}

	if(end_date == ""){
		end_date = Date.now().set({minute: 0, second:0}).add(1).hour();
	}
	else{
		end_date = Date.parse(end_date.replace(".000000", "")).setTimezoneOffset(0);
	}

	var options = {
		pickSeconds: false,
		pick12HourFormat: true
	};

	var start_picker = $("#start-date").datetimepicker(options).data("datetimepicker");
	var end_picker 	 = $("#end-date").datetimepicker(options).data("datetimepicker");

	format = "yyyy-MM-dd HH:mm tt";
	
	start_picker.setLocalDate(start_date);
	end_picker.setLocalDate(end_date);

	getConcurentEvents();
	$("#start-date").on("changeDate", getConcurentEvents);
	$("#end-date").on("changeDate", getConcurentEvents);
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
	var date = Date.parse($("#event_start_date").val(),"yyy-MM-dd HH:mm PP");
	return date.toString()
}

function getEndDate(){
	var date = Date.parse($("#event_end_date").val(),"yyy-MM-dd HH:mm PP");
	return date.toString()
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