module RecordsHelper

  def tag_it_list tags
    return if !tags.size

    tags.map { |t| content_tag(:li, t.label) }.join.html_safe
  end
end
