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
	$("#start-date").on("changeDate", function(ev){
    if(ev.date.valueOf() > end_picker._date.valueOf()){
      var newDate = new Date(ev.date)
      newDate.setHours(newDate.getHours()+1);
      end_picker.setValue(newDate);
    }
    getConcurentEvents();
  });
	$("#end-date").on("changeDate", getConcurentEvents);

    attachKeyListener( $(".limited-chars") );

    // Add conditionally required fields
    $("#event_featured").click(function(event){
        if( $(this).is(":checked") ) {
            $("#event_short_description").attr("required", "required");
            $("#event_image").attr("required", "required");
        } else {
            $("#event_short_description").removeAttr("required");
            $("#event_image").removeAttr("required");
        }
    });
});

function getConcurentEvents(){
	var startDate = getStartDate();
	var endDate = getEndDate();

	$("#other-events-error").hide();
	$("#other-events-loading").show();

	$.ajax({
		url: window.location.origin + "/events.json?start_date=" + 
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


/* Attaches a listener to the container's keypress event */
function attachKeyListener(elements){
  for(var i = 0, len = elements.length; i < len; i++){
    var e = $(elements[i]);
    var textarea = e.find("textarea").first();
    var remaining = e.find(".remaining").first();
    var message = e.find(".remaining-message").first();
    var max = parseInt(textarea.attr("maxlength"), 10);
    var min = parseInt(textarea.data("minlength"), 10);
    var message_wrapper = e.find(".length-message");
  
    var handler = function(){
      var length = textarea.val().length;

      message_wrapper.removeClass();
      message_wrapper.addClass("length-message");

      if(length < min){
        remaining.text(min - length);
        message.text( (min - length) == 1 ? "character to go..." : "characters to go..." );
      } else if( length <= max ){
        remaining.text(max - length);
        message.text( (max - length) == 1 ? "character left" : "characters left" );
      } else {
        remaining.text(length - max);
        message.text("too many characters!");
      }

      if( length >= max ){
        message_wrapper.addClass("text-error");
      } else if( max - length < 10 ){
        message_wrapper.addClass("text-warning");
      } else if( length >= min ){
        message_wrapper.addClass("text-success");
      }

    };

    handler();
    textarea.keyup(handler);
  }
}
