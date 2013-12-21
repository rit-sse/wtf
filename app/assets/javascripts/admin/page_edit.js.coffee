$ -> new pageedit.Section($(section)) for section in $("#page_edit .section")
$ -> acesetup()

editors = []
MarkdownMode = require("ace/mode/markdown").Mode

marked.setOptions({
  gfm: true,
  tables: true,
  breaks: true,
  pedantic: false,
  sanitize: false,
  smartLists: true,
  langPrefix: 'language-',
  highlight: (code, lang) -> 
    #If we add syntax highlighting on the server, 
    #put the client code to do so here
    return code
})

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
    editor.resize()

    # set up change handler for forms
    textarea = $(this).siblings("textarea")
    content_id = "#preview_"+$(this).parent().attr("id").split("_")[1]
    content_area = $(content_id+" .markdown_preview")
    editor.getSession().on 'change', (change) ->
      textarea.text editors[id].getSession().getValue()
      content_area.html( marked(editors[id].getSession().getValue()) )
    
    proper_id = "#"+$(this).parent().parent().siblings().first().attr("id")
    $(proper_id+' a').click((e) ->
      e.preventDefault()
      $(this).tab('show')
    )


pageedit =
  Section: class
    constructor: (@element) ->
      @blocks = []
      @blocks.push(new pageedit.Block(this, $(block))) for block in @element.find(".block")
      @element.find(".available_blocks a").click (event) => this.addBlock($(event.target)); false

    addBlock: (link) ->
      $.get link.attr("href"), (form) =>
        block = new pageedit.Block(this, $(form).find(".block"), true)
        @blocks.push(block)
        @element.find(".blocks").append(block.element)
        acesetup()

    swapBlocks: (blockA, blockB) ->
      a = @blocks.indexOf(blockA)
      b = @blocks.indexOf(blockB)
      @blocks[a] = blockB
      @blocks[b] = blockA
      blockA.setPosition(b + 1)
      blockB.setPosition(a + 1)
      if a > b
        blockA.element.insertBefore(blockB.element)
      else
        blockA.element.insertAfter(blockB.element)

    removeBlock: (block) ->
      this.swapBlocks(block, @blocks[i+1]) while (i = @blocks.indexOf(block)) < @blocks.length - 1
      @blocks.pop()

  Block: class
    constructor: (@section, @element, @newRecord=false) ->
      @element.find(".delete").click => this.delete(); false

    delete: ->
      return unless confirm "Are you sure you want to delete this block?"
      @element.hide()
      @section.removeBlock(this)
      if @newRecord then @element.remove() else @element.find("._destroy").attr("value", true)
