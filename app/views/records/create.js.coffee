App.showLoading()
$(".record-list tbody").append "<%= j render partial: 'records/record', locals: { record: @record } %>"

<% @record = current_user.records.new %>
$(".jumbotron").html "<%= j render partial: 'records/form' %>"
App.hideLoading()
