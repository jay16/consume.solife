window.ConsumeItem = 
  addItem: ->
    $form = $("#consumeItemForm")
    value = $form.find(".value:first").val()
    who   = $form.find(".who:first").val()
    desc  = $form.find(".desc:first").val()
    timestamp = $form.find(".timestamp:first").val()
    $form.find(".action:first").html("")

    $hash = $("#consumeForm .hash:first")
    items = []
    i     = 0 
    _items = JSON.parse($hash.val())
    while i < _items.length
      item = JSON.parse(_items[i])
      if item.timestamp != timestamp
        items.push(_items[i])
      i++
    json = {"timestamp": timestamp, "value": value, "who": who, "desc": desc}
    items.push(JSON.stringify(json))
    $hash.attr("value", JSON.stringify(items))

  editItem: (timestamp) ->
    hash = $("#consumeForm .hash:first").val()
    item = {} 
    i    = 0 
    items = JSON.parse(hash)
    while i < items.length
      _item = JSON.parse(items[i])
      if _item.timestamp = timestamp
        item = _item
        break
      i++
    $form = $("#consumeItemForm")
    $form.find(".timestamp:first").val(item.timestamp)
    $form.find(".value:first").val(item.value)
    $form.find(".who:first").val(item.who)
    $form.find(".desc:first").val(item.desc)
    $a = $("<a onclick='ConsumeItem.dropItem(" + item.timestamp + ");')></a>")
      .addClass("btn btn-danger")
      .text("删除")
    $form.find(".action:first").append($a)

    $("#consumeModal").addClass("hidden")
    $("#consumeItemModal").removeClass("hidden")

  listItems: ->
    $hash = $("#consumeForm .hash:first")
    items = JSON.parse($hash.val())
    $table = $("<table></table>").addClass("table table-condensed table-striped")
    i = 0
    len = items.length
    while i < len
      item = JSON.parse(items[i])
      $tr = $("<tr></tr>").attr("id", item.timestamp)
        .addClass("success")
      td = "<td></td>"
      $tr.append($(td).text("￥" + item.value))
      $tr.append($(td).text(item.who))
      $tr.append($(td).text(item.desc))
      $a = $("<a onclick='ConsumeItem.editItem(" + item.timestamp + ");')></a>")
        .addClass("btn btn-sm")
        #.bind "click", ->
        #  alert(item.timestamp) # it will dynamically revalue as last item
        .html('<span class="glyphicon glyphicon-pencil"></span>')
      $tr.append($(td).append($a))
      $table.append($tr) 
      i++
    $(".consume-items").html($table)

  # submit create consume_item
  create: ->
    $form = $("#consumeItemForm")
    $validator = $form.data("bootstrapValidator")
    $validator.validate()
    if $validator.isValid()
      ConsumeItem.addItem()
      ConsumeItem.listItems()
      ConsumeItem.back()
      App.resetForm($form) 
    else
      App.printBootstrapValidatorErrors($validator)

  # cancel create consume_item
  back: ->
    $consume = $("#consumeModal")
    $consumeItem = $("#consumeItemModal")
    $consume.removeClass("hidden")
    $consumeItem.addClass("hidden")


$(document).ready ->

  $("#consumeItemForm").bootstrapValidator
    message: "填写项不符全要求."
    feedbackIcons:
      valid: "glyphicon glyphicon-ok"
      invalid: "glyphicon glyphicon-remove"
      validating: "glyphicon glyphicon-refresh"

    fields:
      "consume_item['value']":
        validators:
          notEmpty:
            message: "消费数值为必填项."
          regexp:
            regexp: /[0-9]+([\.|,][0-9]+)?/
            message: "消费数值必须为浮点型."
