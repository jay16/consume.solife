$("#<%= dom_id @record %>").remove()
$("#user_report").replaceWith "<%= j render partial: 'users/user_report' %>"
