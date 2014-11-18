App.showLoading()
$(".records-list tbody").prepend "<%= j render partial: 'records/record', locals: { record: @record } %>"
App.hideLoading()
