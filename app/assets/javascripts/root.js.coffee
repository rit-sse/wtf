$(window).load ->
  $("#featured").orbit(
    timer: true,
    advanceSpeed: 6000,
    pauseOnHover: true,
    startClockOnMouseOut: true,
    # startClockOnMouseOutAfter: 500,
    # directionalNav: false,
    bullets: true
  )

