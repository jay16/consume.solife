window.RecordItem = 
  filterWithTimestamp: (items, timestamp) ->
    _items  = []
    _items.push(item) for item in items when JSON.parse(item).timestamp != timestamp
    return _items

  addItem: ->
    $form = $("#recordItemForm")
    # drop-btn only show when edit
    $form.find(".action-drop").html("")
    # collect values
    value = $form.find("input[name='record_item[value]']").val()
    who   = $form.find("input[name='record_item[who]']").val()
    desc  = $form.find("textarea[name='record_item[desc]']").val()
    timestamp = $form.find("input[name='record_item[timestamp]']").val()

    item   = {"timestamp": timestamp, "value": value, "who": who, "desc": desc}
    $hash  = $("#recordForm input[name='record[items]']")
    # delete exist and then add 
    items  = RecordItem.filterWithTimestamp(JSON.parse($hash.val()), timestamp)
    # items.push(_item) for _item in _items when JSON.parse(_item).timestamp != timestamp
    items.push(JSON.stringify(item))
    $hash.attr("value", JSON.stringify(items))

  # edit a created record item with timetamp
  editItem: (timestamp) ->
    # get record item list
    $hash = $("#recordForm input[name='record[items]']")
    item = {} 
    items = JSON.parse($hash.val())
    for _item in items 
      json = JSON.parse(_item)
      if parseInt(json.timestamp) is parseInt(timestamp)
        item = json
        break
    $form = $("#recordItemForm")
    $form.find("input[name='record_item[timestamp]']").val(item.timestamp)
    $form.find("input[name='record_item[value]']").val(item.value)
    $form.find("input[name='record_item[who]']").val(item.who)
    $form.find("textarea[name='record_item[desc]']").val(item.desc)
    $a = $("<a></a>")# onclick='RecordItem.dropItem(" + item.timestamp + ");')></a>")
      .bind "click", ((e) ->
        ->
          RecordItem.dropItem(e.timestamp)
      )(item)
      .addClass("btn btn-danger")
      .text("删除")
    $form.find(".action-drop").html($a)

    $("#recordModal").addClass("hidden")
    $("#recordItemModal").removeClass("hidden")

  dropItem: (timestamp) ->
    $form = $("#recordItemForm")
    timestamp = $form.find("input[name='record_item[timestamp]']").val()

    $hash  = $("#recordForm input[name='record[items]']")
    #_items = JSON.parse($hash.val())
    #items  = []
    #items.push(item) for item in _items when JSON.parse(item).timestamp != timestamp
    items  = RecordItem.filterWithTimestamp(JSON.parse($hash.val()), timestamp)
    $hash.attr("value", JSON.stringify(items))
    RecordItem.listItems()
    RecordItem.back()
    App.resetForm($form) 
    $form.find(".action-drop").html("")

  listItems: ->
    $hash = $("#recordForm input[name='record[items]']")
    items = JSON.parse($hash.val())
    $table = $("<table></table>").addClass("table table-condensed table-striped")
    # asign record#remark/value
    remark = ""
    value = 0
    for _item in items
      item  = JSON.parse(_item)
      remark += [item.value, item.who, item.desc].join(" - ") + "\n"
      value += parseInt(item.value)

      $tr = $("<tr></tr>").attr("id", item.timestamp).addClass("success")
      td = "<td></td>"
      $tr.append($(td).text("￥" + item.value))
      $tr.append($(td).text(item.who))
      $tr.append($(td).text(item.desc))
      $a = $("<a></a>") # onclick='RecordItem.editItem(" + item.timestamp + ");')></a>")
        .bind "click", ((e) ->
          ->
            RecordItem.editItem(e.timestamp)
        )(item)
        .addClass("btn btn-sm")
        #.bind "click", ->
        #  alert(item.timestamp) # it will dynamically revalue as last item
        .html('<span class="glyphicon glyphicon-pencil"></span>')
      $tr.append($(td).append($a))
      $table.append($tr) 

    # show items list as table
    $(".record-items").html($table)
    # asign desc
    $remark = $("#recordForm input[name='record[remark]']")
    $value = $("#recordForm input[name='record[value]']")
    $remark.attr("value", remark)
    $value.attr("value", value)

  # submit create record_item
  create: ->
    $form = $("#recordItemForm")
    $submit = $("#record_submit")
    $validator = $form.data("bootstrapValidator")
    $validator.validate()
    if $validator.isValid()
      RecordItem.addItem()
      RecordItem.listItems()
      RecordItem.back()
      App.resetForm($form) 
      $submit.removeAttr("disabled")
    else
      App.printBootstrapValidatorErrors($validator)

  # cancel create record_item
  back: ->
    $record = $("#recordModal")
    $recordItem = $("#recordItemModal")
    $record.removeClass("hidden")
    $recordItem.addClass("hidden")


$(document).ready ->

  $("#recordItemForm").bootstrapValidator
    message: "填写项不符全要求."
    feedbackIcons:
      valid: "glyphicon glyphicon-ok"
      invalid: "glyphicon glyphicon-remove"
      validating: "glyphicon glyphicon-refresh"

    fields:
      "record_item[value]":
        validators:
          notEmpty:
            message: "消费数值为必填项."
          regexp:
            regexp: /[0-9]+([\.|,][0-9]+)?/
            message: "消费数值必须为浮点型."
