module RecordsHelper

  def tag_it_list record
    return if record.nil?
    (record.tags.map(&:label)+ record.tags_list.split(","))
    .uniq.map { |l| content_tag(:li, l) }.join.html_safe
  end
end
