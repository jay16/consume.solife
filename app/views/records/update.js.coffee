$domRecord = $("#<%= dom_id @record %>")
$domRecord.replaceWith "<%= j render partial: 'records/record', locals: { record: @record } %>"
$domRecord.removeClass "active"

<% @record = current_user.records.new %>
$(".record_form").html "<%= j render partial: 'records/form' %>"

