module RecordsHelper

  def tag_it_list(record)
    return if record.nil?

    (record.tags.map(&:label)+ record.tags_list.split(","))
    .uniq.map { |l| content_tag(:li, l) }
    .join.html_safe
  end

  def cache_key_for_record(records)
    size = records.size
    keystamp =  size.zero? ? 0 : records.first.updated_at.try(:utc).try(:to_s, :number)
    "current_user/records/paginate-#{size}-#{keystamp}"
  end
end
