App.showLoading()
$domRecord = $("#<%= dom_id @record %>")
$domRecord.replaceWith "<%= j render partial: 'records/record', locals: { record: @record, user_id: current_user.id } %>"
$domRecord.removeClass "active"

$("#user_report").replaceWith "<%= j render partial: 'users/user_report' %>"


$state = $(".checkbox-ctl-tag:first").attr("checked")
if $state != undefined
  $(".record-tag").removeClass("hidden")
$state = $(".checkbox-ctl-edit:first").attr("checked")
if $state != undefined
  $(".operation-edit").removeClass("hidden")
$state = $(".checkbox-ctl-del:first").attr("checked")
if $state != undefined
  $(".operation-del").removeClass("hidden")

$modal = $("#recordEditModal")
$modal.find(".modal-title").first().html "loading..."
$modal.find(".modal-body").first().html "loading..."
$modal.modal("hide")
App.hideLoading()
