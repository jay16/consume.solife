module RecordsHelper

  def tag_it_list record
    return if record.nil?
    (record.tags.map { |t| t.label } + record.tags_list.split(","))
    .uniq.map { |l| content_tag(:li, l) }.join.html_safe
  end

  def tag_it_list tags
    return if !tags.size
    tags.map { |t| content_tag(:li, t.label) }.join.html_safe
  end
end
