# TagsController 下所有页面的JS功能
window.Tags =

  # tag-it控件选择标签
  initTagIt : (target) ->
    sampleTags = [
      "c++"
      "java"
      "php"
      "coldfusion"
      "javascript"
      "asp"
      "ruby"
      "python"
      "c"
      "scala"
      "groovy"
      "haskell"
      "perl"
      "erlang"
      "apl"
      "cobol"
      "go"
      "lua"
    ]

    #-------------------------------
    # Tag events
    #-------------------------------
    eventTags = $(target)
    addEvent = (text) ->
      tags_list = []
      eventTags.find(".tagit-choice:not(.removed)").each ->
         tags_list.push $(this).find(".tagit-label:first").text()
      $("#events_container").html text + "<br>" + tags_list.join(",")
      $("#record_tags_list").val(tags_list.join(","));
      return

    eventTags.tagit
      availableTags: sampleTags
      beforeTagAdded: (evt, ui) ->
        addEvent "beforeTagAdded: " + eventTags.tagit("tagLabel", ui.tag)  unless ui.duringInitialization
        return

      afterTagAdded: (evt, ui) ->
        addEvent "afterTagAdded: " + eventTags.tagit("tagLabel", ui.tag)  unless ui.duringInitialization
        return

      beforeTagRemoved: (evt, ui) ->
        addEvent "beforeTagRemoved: " + eventTags.tagit("tagLabel", ui.tag)
        return

      afterTagRemoved: (evt, ui) ->
        addEvent "afterTagRemoved: " + eventTags.tagit("tagLabel", ui.tag)
        return

      onTagClicked: (evt, ui) ->
        addEvent "onTagClicked: " + eventTags.tagit("tagLabel", ui.tag)
        return

      onTagExists: (evt, ui) ->
        addEvent "标签已经选过: " + eventTags.tagit("tagLabel", ui.existingTag)
        return

