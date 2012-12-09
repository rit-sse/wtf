$ ->
  autofocus = ->
    $("form.autofocus").each ->
      firstInput = $(this).children("div.field").children("input[type=text]").first()
      firstInput.focus() unless firstInput.val().length > 0

  #autofocus()

  $(".ace").each ->
    # set up ace - currently we can only handle one editor at a time
    editor = ace.edit(this)
    window.editor = editor

    # configure editor
    editor.setTheme "ace/theme/textmate"
    MarkdownMode = require("ace/mode/markdown").Mode
    editor.getSession().setMode(new MarkdownMode())
    editor.getSession().setTabSize 2
    editor.setHighlightActiveLine true

    # intentionally un-focus the ace editor...it seems to want to grab focus
    # when it's created
    editor.blur()
    #autofocus()

    # resize parent container
    h = $(this).outerHeight(true)
    h2 = $(this).parent().outerHeight(true)
    $(this).parent().css height: h + h2

    # set up change handler for forms
    textarea = $(this).siblings("textarea")
    editor.getSession().on 'change', (change) ->
      textarea.text window.editor.getSession().getValue()

