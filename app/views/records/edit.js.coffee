App.showLoading()
$("#<%= dom_id @record %>").addClass "active"

$modal = $("#recordEditModal")
$modal.find(".modal-title").first().html "编辑"
$modal.find(".modal-body").first().html "<%= j render partial: 'records/form' %>"
$modal.modal("show")

App.hideLoading()
