$ ->
  bindDestroyClick = (element) ->
    element = $(".destroy") unless element
    element.click ->
      $(this).parent().remove()
      return false

  $("#add_event_price_button").click ->
    added = $(".input-prepend:last").before ->
      $(".price_prototype").html()
    bindDestroyClick(added.children("a.destroy")[0])
    return false

  bindDestroyClick()
