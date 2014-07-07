window.Home = 
  downloadAndroid: ->
    if $(".cache-list").hasClass("hidden")
      $(".cache-list").removeClass("hidden")
      $(".mobile").addClass("hidden")
    else
      $(".cache-list").addClass("hidden")
      $(".mobile").addClass("hidden")
      $(".android").removeClass("hidden")
    Home.resizeWindow()

  resizeWindow: ->
    w = window
    d = document
    e = d.documentElement
    g = d.getElementsByTagName("body")[0]
    x = w.innerWidth or e.clientWidth or g.clientWidth
    y = w.innerHeight or e.clientHeight #|| g.clientHeight;
    $("body").css
      height: y + "px"
      overflow: "hidden"

    $("#footer").css
      "min-height": "70px"
      "padding-top": "15px"

    nh = $("#nav").height()
    sh = $("#slogn").height()
    fh = $("#footer").height()
    ch = y - nh - sh - fh
    $("#cache").css
      height: ch + "px"
      overflow: "hidden"

    $("#cache").scrollTop $("#cache")[0].scrollHeight

$ ->
  Home.resizeWindow()
  $(window).resize ->
    Home.resizeWindow()

  $("body").tooltip
    selector: "[data-toggle=tooltip]"
    container: "body"

  $("body").popover
    selector: "[data-toggle=popover]"
    container: "body"
