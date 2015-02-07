window.Home = 
  downloadMobileClient: (self, klass) ->
    if $(".cache-list").hasClass("hidden")
      $(".cache-list").removeClass("hidden")
      $(".cache-list").slideDown("slow")
      $(".mobile").slideUp("slow")
      $(".mobile").addClass("hidden")
      $(self).removeClass("onfocus")
    else
      $(".cache-list").slideUp("slow")
      $(".cache-list").addClass("hidden")
      $(".mobile").addClass("hidden")
      $("." + klass).removeClass("hidden")
      $("." + klass).slideDown("slow")
      $(self).addClass("onfocus")

  resizeWindow: ->
    w = window
    d = document
    e = d.documentElement
    g = d.getElementsByTagName("body")[0]
    x = w.innerWidth or e.clientWidth or g.clientWidth
    y = w.innerHeight or e.clientHeight #|| g.clientHeight;
    $("body").css
      height: y + "px"

    nh = $("#nav").height()
    sh = $("#slogn").height()
    fh = $("#footer").height()
    ch = y - nh - sh - fh
    $("#cache").css
      height: ch + "px"
    #$("#cache").scrollTop $("#cache")[0].scrollHeight
