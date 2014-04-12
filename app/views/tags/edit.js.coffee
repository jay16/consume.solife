$("#<%= dom_id @tag %>").append "<div class='edit-form'></div>"
$show_form = $("#<%= dom_id @tag %> .show-form")
$edit_form = $("#<%= dom_id @tag %> .edit-form")
$show_form.css("display","none")
$edit_form.html "<%= j render partial: 'form' %>"
$edit_form.css("display","show")
