# TagsController 下所有页面的JS功能
window.Tags =

  # 编辑时标签时，取消提交
  # tag_id: 标签id
  cancelEdit : (tag_id) ->
    $dom_tag = $("#tag_"+tag_id) 
    $dom_tag.find(".edit-form").remove()
    $dom_tag.find(".show-form").css("display","block")

  # tag-it控件选择标签
  # target: tag-it容器
  # tags: 已创建标签数组
  # control: input加载标签字符串
  # show_pane: 显示面板
  initTagIt : (target,tags,control,show_pane) ->
    $eventTags = $(target)
    sampleTags = tags
    $control = $(control)
    $show_pane = $(show_pane)

    addEvent = (text) ->
      tags_list = []
      $eventTags.find(".tagit-choice:not(.removed)").each ->
         tags_list.push $(this).find(".tagit-label:first").text()

      $show_pane.html text + "<br>" + tags_list.join(",") if show_pane.length
      $control.val(tags_list.join(",")) 
      return

    $eventTags.tagit
      availableTags: sampleTags
      beforeTagAdded: (evt, ui) ->
        addEvent "beforeTagAdded: " + $eventTags.tagit("tagLabel", ui.tag)  unless ui.duringInitialization
        return

      afterTagAdded: (evt, ui) ->
        addEvent "afterTagAdded: " + $eventTags.tagit("tagLabel", ui.tag)  unless ui.duringInitialization
        return

      beforeTagRemoved: (evt, ui) ->
        addEvent "beforeTagRemoved: " + $eventTags.tagit("tagLabel", ui.tag)
        return

      afterTagRemoved: (evt, ui) ->
        addEvent "afterTagRemoved: " + $eventTags.tagit("tagLabel", ui.tag)
        return

      onTagClicked: (evt, ui) ->
        addEvent "onTagClicked: " + $eventTags.tagit("tagLabel", ui.tag)
        return

      onTagExists: (evt, ui) ->
        addEvent "标签已经选过: " + $eventTags.tagit("tagLabel", ui.existingTag)
        return

