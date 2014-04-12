$dom_tag = $("#<%= dom_id @tag %>")
$dom_tag.replaceWith "<%= j render partial: 'tag', locals: { tag: @tag } %>"
$dom_tag.find(".show-form:first").addClass("alert alert-success")
