App.showLoading()
$(".records-list tbody").prepend "<%= j render partial: 'records/record', locals: { record: @record } %>"

<% @record = current_user.records.new %>
<% @record.ymdhms = Time.now.strftime("%Y-%m-%d %H:%M:%S") %>
$(".jumbotron").html "<%= j render partial: 'records/form' %>"
App.hideLoading()
