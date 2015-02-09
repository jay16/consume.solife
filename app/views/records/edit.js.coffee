App.showLoading()

$("#<%= dom_id @record %>").addClass "active"

$modal = $("#recordEditModal")
$modal.find(".modal-title").first().html "编辑"
$modal.find(".modal-body").first().html "<%= j render partial: 'records/form' %>"
$modal.modal("show")

$form = $("#edit_<%= dom_id @record %>")
$form.bootstrapValidator
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
          format: 'YYYY/MM/DD HH:mm:ss'
          message: "日期格式错误."

App.hideLoading()
