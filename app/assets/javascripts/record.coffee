window.Record = 
  # datepicker change date
  showModal: ->
    $datetimePicker = $('#datetimePicker')
    $datetimePicker.data("DateTimePicker").setDate(new Date())

    $("#recordFormModal").modal("show")

  initForm: ->
    $recordItemForm = $("#recordItemForm")
    $recordItemForm.find(".action-drop").html("")
    App.resetForm($recordItemForm) 

    $recordForm = $("#recordForm")
    $recordForm.find("input[name='record[items]']").val("[]")
    $recordForm.find("input[name='record[desc]']").val("[]")
    $recordForm.find(".record-items").html("")
    $recordForm.data('bootstrapValidator').resetForm(true)

  # add record item
  addItem: ->
    $record = $("#recordModal")
    $recordItem = $("#recordItemModal")
    $recordItem.removeClass("hidden")
    $record.addClass("hidden")

    #App.resetForm($form) 
    # init item timestamp
    timestamp = new Date().getTime()
    $("#recordItemForm input[name='record_item[timestamp]']").val(timestamp)

  # submit create record
  create: ->
    $form = $("#recordForm")
    $validator = $form.data("bootstrapValidator")
    $validator.validate()
    if $validator.isValid()
      #Record.initForm()
      $form.submit()
      $(".modal").modal("hide")

$(document).ready ->
  $recordForm = $("#recordForm")
  $datetimePicker = $('#datetimePicker')
  $datetimePicker.datetimepicker
    format: 'YYYY/MM/DD HH:mm'
    defaultDate: new Date()

  $recordForm.bootstrapValidator
    message: "填写项不符全要求."
    feedbackIcons:
      valid: "glyphicon glyphicon-ok"
      invalid: "glyphicon glyphicon-remove"
      validating: "glyphicon glyphicon-refresh"

    fields:
      "record[value]":
        validators:
          notEmpty:
            message: "消费数值为必填项."
          regexp:
            regexp: /[0-9]+([\.|,][0-9]+)?/
            message: "消费数值必须为浮点型."
      "record[ymdhms]":
        validators: 
          notEmpty: 
            message: '消费日期为必填项.'
          date: 
            format: 'YYYY/MM/DD HH:mm'

  $datetimePicker.on 'dp.change dp.show', (e) ->
    # Revalidate the date when user change it
    $recordForm.bootstrapValidator("revalidateField", "record[ymdhms]")
