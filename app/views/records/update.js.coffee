$tr = $("#tr_<%= dom_id @record %>")
$tr.replaceWith "<%= j render partial: 'records/record', locals: { record: @record } %>"
$tr.removeClass "active"

<% @record = current_user.records.new %>
$(".record_form").html "<%= j render partial: 'records/form' %>"

