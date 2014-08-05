module Cpanel::CommentsHelper
  def cpanel_cache_key_for_comment(comments)
    size = comments.size
    keystamp = size.zero? ? 0: comments.first.updated_at.try(:utc).try(:to_s, :number)
    "cpanel/comments/paginate-#{size}-#{keystamp}"
  end
end
