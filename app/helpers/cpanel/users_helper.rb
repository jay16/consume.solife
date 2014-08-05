module Cpanel::UsersHelper
  def cpanel_cache_key_for_user(users)
    size = users.size
    keystamp = size.zero? ? 0 : users.first.updated_at.try(:utc).try(:to_s, :number)
    "cpanel/users/paginate-#{size}-#{keystamp}"
  end
end
