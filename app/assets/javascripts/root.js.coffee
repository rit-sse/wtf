$ ->
    $("#new_header").carousel('next')
    $("#new_header").carousel('cycle')
    
    already_editing = false
    
    current_slide = ->
        $('#new_header .active').index('#new_header .item')
        
    current_slide_uuid = ->
        $('#new_header .active').attr('id').split('_')[2] or 0
        
    current_slide_content = ->
        $('#new_header .active').html()
        
    last_slide_id = ->
        ($('.item').length-1)
    
    if $("#orbit_new")
        $("#orbit_new").click( (event) ->
            event.preventDefault()
            $(".carousel-inner").append(
                "<div class=\"item\" id=\"new_page\"></div>"
            )
            $("#new_header").carousel(last_slide_id())
            $("#orbit_edit").trigger('click')
        )
        
        $("#orbit_delete").click( (event) ->
            event.preventDefault()
            if confirm("Are you sure you want to trash this page?")
                $.get("/orbiter/destroy",{id: current_slide_uuid()},(status, result, XHR) -> 
                    if not status 
                        alert(result) 
                    else 
                        location.reload(true)
                )
        )
        
        $("#orbit_edit").click( (event) ->
            event.preventDefault()
            
            if already_editing
                return false
                
            already_editing = true
            
            
            
            $("#header_wrapper").append(
                "<div id=\"edit_wrapper\" style=\"height: 331px; margin: 0 auto; width: 940px;\"><div class=\"ace\" id=\"edit_orbit\" style=\"position:relative; margin: 6px auto; top:-40px;\"></div></div>"
            )
            
            editor = ace.edit("edit_orbit");
            editor.getSession().setMode("ace/mode/html")
            editor.getSession().on('change', (event) -> 
                $('#new_header .active').html(editor.getValue())
            )
            editor.setValue(String(current_slide_content()))
            
            $("#new_header").on('slid', (event) ->
                editor.setValue(String(current_slide_content()))
            )
            
            $("#edit_wrapper").prepend(
                """
                <div style="position:relative; left:100%; top:6px; margin:6px; width:20px;">
                    <a id="orbit_save" href="/" style="margin:6px;"><i class="icon-ok"></i></a>
                    <a id="orbit_cancel" href="/" style="margin:6px;"><i class="icon-remove"></i></a>
                </div>
                """
            )
            
            $("#orbit_cancel").click( (event) ->
                if confirm("Discard all changes?")
                    return
                else
                    event.preventDefault()
            )
            
            $("#orbit_save").click( (event) ->
                if confirm("Save the current page to the server?")
                    #POST REQUEST
                    event.preventDefault()
                    $.post(
                        "/orbiter/edit",
                        {
                            id: current_slide_uuid(),
                            content: String(current_slide_content())
                        },
                        (data, status, XHR) ->
                            if status == "success"
                                location.reload(true)
                            else
                                alert("There was a problem processing your request.")
                    )
                else
                    event.preventDefault()
            )
            $("#new_header").carousel({
                interval: null
            })
            $("#new_header").carousel('pause')
        )