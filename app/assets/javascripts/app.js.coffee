$ ->
  autofocus = ->
    $("form.autofocus").each ->
      firstInput = $(this).children("div.field").children("input[type=text]").first()
      firstInput.focus() unless firstInput.val().length > 0

  #autofocus()

