window.ConsumeItem = 
  addItem: ->
    timestamp = new Date().getTime()
    value = $("#consumeItemForm .value:first").val()
    who   = $("#consumeItemForm .who:first").val()
    desc  = $("#consumeItemForm .desc:first").val()
    $hash = $("#consumeForm .hash:first")
    array = JSON.parse($hash.val())
    json = {"timestamp": timestamp, "value": value, "who": who, "desc": desc}
    array.push(JSON.stringify(json))
    $hash.attr("value", JSON.stringify(array))

  # submit create consume_item
  create: ->
    $form = $("#consumeItemForm")
    $validator = $form.data("bootstrapValidator")
    $validator.validate()
    if $validator.isValid()
      ConsumeItem.addItem()
      ConsumeItem.back()
      $validator.resetForm(true)
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
      "consume_item['who']":
        validators:
          notEmpty:
            message: "参与者为必填项."
