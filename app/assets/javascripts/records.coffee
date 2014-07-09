# TagsController 下所有页面的JS功能
#= require "multi_selector"
window.Records =
  
  # 同时上传多张图片
  multiFileUpload : (input_file, show_pane) ->
    # Create an instance of the multiSelector class, 
    # pass it the output target and the max number of files
    multi_selector = new MultiSelector( document.getElementById(show_pane), 30 );
    # Pass in the file element
    multi_selector.addElement( document.getElementById(input_file) );
   
  toggleShow: (self, klass) ->
    state = $(self).attr("checked")
    if state == undefined
      $(self).attr("checked", "true")
      $(klass).removeClass("hidden")
    else
      $(self).removeAttr("checked")
      $(klass).addClass("hidden")


