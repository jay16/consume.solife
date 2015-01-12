App.showLoading()
#$(".records-list tbody").prepend "<%= j render partial: 'records/record', locals: { record: @record } %>"
#$("#record_form_modal").html "<%= j render partial: 'records/consume_form_modal' %>"
window.location.reload()
App.hideLoading()
