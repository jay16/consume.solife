module TagsHelper
  def cache_key_for_tag(tags)
    size = tags.size
    keystamp = size.zero? ? 0 : tags.first.updated_at.try(:utc).try(:to_s, :number)
    "current_user/tags/paginate-#{size}-#{keystamp}"
  end
end
