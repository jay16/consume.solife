module RecordsHelper

<<<<<<< HEAD
  def tag_it_list record
    return if record.nil?
    (record.tags.map { |t| t.label } + record.tags_list.split(","))
    .uniq.map { |l| content_tag(:li, l) }.join.html_safe
=======
  def tag_it_list tags
    return if !tags.size

    tags.map { |t| content_tag(:li, t.label) }.join.html_safe
>>>>>>> d912a81dcb184f299cd83b00b40589470505e6c8
  end
end
