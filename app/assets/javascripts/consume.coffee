window.Consume = 
  addItem: ->
    $consume = $("#consumeModal")
    $consumeItem = $("#consumeItemModal")
    $consumeItem.removeClass("hidden")
    $consume.addClass("hidden")

  # submit create consume_item
  create: ->
    $form = $("#consumeForm")
    $validator = $form.data("bootstrapValidator")
    $validator.validate()
    #  ConsumeItem.addItem()
    console.log($validator.isValid())


$(document).ready ->
  $consumeForm = $("#consumeForm")
  $datetimePicker = $('#datetimePicker')
  $datetimePicker.datetimepicker()

  $consumeForm.bootstrapValidator
    message: "填写项不符全要求."
    feedbackIcons:
      valid: "glyphicon glyphicon-ok"
      invalid: "glyphicon glyphicon-remove"
      validating: "glyphicon glyphicon-refresh"

    fields:
      "consume['value']":
        validators:
          notEmpty:
            message: "消费数值为必填项."
          regexp:
            regexp: /[0-9]+([\.|,][0-9]+)?/
            message: "消费数值必须为浮点型."
      "consume['ymdhms']":
        validators: 
          notEmpty: 
            message: 'The date is required and cannot be empty'
          date: 
            format: 'MM/DD/YYYY h:m A'

  $datetimePicker.on 'dp.change dp.show', (e) ->
    # Revalidate the date when user change it
    $consumeForm.bootstrapValidator("revalidateField", "consume['ymdhms']")
