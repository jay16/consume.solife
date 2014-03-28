$("#tr_<%= dom_id @record %>").addClass "active"
$(".record_form").html "<%= j render partial: 'records/form' %>"
