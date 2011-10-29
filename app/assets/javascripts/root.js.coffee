$(window).load ->
  $("#featured").orbit(
    timer: true,
    advanceSpeed: 6000,
    pauseOnHover: true,
    startClockOnMouseOut: true,
    # startClockOnMouseOutAfter: 500,
    # directionalNav: false,
    captionAnimation: 'slideOpen',
    captionAnimationSpeed: 100,
    bullets: true
  )

