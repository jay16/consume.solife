App.showLoading()
$modal = $("#recordEditModal")
$modal.modal("hide")
$modal.find(".modal-title").first().html "loading..."
$modal.find(".modal-body").first().html "loading..."
console.log("hide modal.")

$domRecord = $("#<%= dom_id @record %>")
$domRecord.replaceWith "<%= j render partial: 'records/record', locals: { record: @record, user_id: current_user.id } %>"
$domRecord.removeClass "active"
console.log("record update view.")

$("#user_report").replaceWith "<%= j render partial: 'users/user_report' %>"
console.log("user report update view.")

$state = $(".checkbox-ctl-tag:first").attr("checked")
if $state != undefined
  $(".record-tag").removeClass("hidden")
$state = $(".checkbox-ctl-edit:first").attr("checked")
if $state != undefined
  $(".operation-edit").removeClass("hidden")
$state = $(".checkbox-ctl-del:first").attr("checked")
if $state != undefined
  $(".operation-del").removeClass("hidden")

App.hideLoading()
