window.User = 
  inputMonitor: (self, klass) ->
    if $(self).val().length
      $(klass).removeAttr("disabled")
    else
      $(klass).attr("disabled", "disabled")
