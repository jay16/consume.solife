# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https:#github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.
# require_tree .
#
#= require jquery
#= require jquery_ujs
#= require turbolinks
#  require bootstrap
#= require jquery.ui
#= require bootstrapValidator.min
#= require moment.min
#= require bootstrap-datetimepicker.min
#= require tag-it
#= require record
#= require record_item
#= require tags
#= require users
#= require home

window.App =
  showLoading: ->
    $(".loading").removeClass("hidden")
  hideLoading: ->
    $(".loading").addClass("hidden")

  toggleShow: (h_k, s_k) ->
    $(h_k).addClass("hidden")
    $(s_k).removeClass("hidden")

  reloadWindow: ->
    window.location.reload()

  cpanelNavbarInit: ->
    pathname = window.location.pathname
    klass = "." + pathname.split("/").join("-")
    console.log(klass)
    $(klass).siblings("li").removeClass("active")
    $(klass).addClass("active")

  deviseResizeWindow: ->
    w = window
    d = document
    e = d.documentElement
    g = d.getElementsByTagName("body")[0]
    x = w.innerWidth or e.clientWidth or g.clientWidth
    y = w.innerHeight or e.clientHeight #|| g.clientHeight;

    nav_height = 80 || $("nav:first").height()
    footer_height = 100 || $("footer:first").height()
    #main_height = y-nav_height-footer_height
    #if main_height > 300
    #  $("#main").css
    #    height: main_height + "px"

  getEnumPropertyNames: (obj) ->
    props = []
    for prop in obj
      props.push prop
    return props
  printBootstrapValidatorErrors: ($validator) ->
    $fields = $validator.getInvalidFields()
    console.log($fields.length + " erros:")
    $fields.each ->
      console.log(this.tagName + "[name=" + $(this).attr("name") + "] - not validator!")

  resetForm: ($form) ->
    $form.find("input").each ->
      $(this).val("")
    $form.find("textarea").each ->
      $(this).val("")

$ ->
  # devise login stay in 12 minute without operation
  # reload the UI to login
  setInterval App.reloadWindow, 1200 * 1000

  # css devise layout
  pathname = window.location.pathname.split("/")
  if pathname[1] == "users"
    App.deviseResizeWindow()
  else if pathname[1] == "cpanel"
    App.cpanelNavbarInit()
  else
    console.log(pathname.join("-"))

  $(".navbar-nav li").bind "click", ->
    $(this).siblings("li").removeClass("active")
    $(this).addClass("active")

  # global bootstrap japavscript plugin
  $('body').tooltip ->
    selector: "[data-toggle=tooltip]"
    container: "body"

  $('body').popover ->
      selector: "[data-toggle=popover]"
      container: "body"
