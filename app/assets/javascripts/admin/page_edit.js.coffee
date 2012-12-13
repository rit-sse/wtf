$ -> new pageedit.Section($(section)) for section in $("#page_edit .section")
$ -> acesetup()

editors = []
MarkdownMode = require("ace/mode/markdown").Mode

acesetup = ->
  $(".aceinit").each ->
    $(this).removeClass("aceinit")
    editor = new ace.edit(this)
    id = editors.push(editor) - 1

    # configure editor
    editor.setTheme "ace/theme/textmate"
    editor.getSession().setMode(new MarkdownMode())
    editor.getSession().setTabSize 2
    editor.getSession().setUseWrapMode true
    editor.renderer.setShowGutter false
    editor.setHighlightActiveLine false
    editor.setShowPrintMargin false
    $(this).css("font-size", '14px')

    # resize parent container
    h = $(this).outerHeight(true)
    h2 = $(this).parent().outerHeight(true)
    $(this).parent().css height: h + h2

    # set up change handler for forms
    textarea = $(this).siblings("textarea")
    editor.getSession().on 'change', (change) ->
      textarea.text editors[id].getSession().getValue()


pageedit =
  Section: class
    constructor: (@element) ->
      @element.find(".available_blocks a").click (event) => this.addBlock($(event.target)); false

    addBlock: (link) ->
      $.get link.attr("href"), (form) =>
        @element.find(".blocks").append($(form).find(".block"))
        acesetup()
