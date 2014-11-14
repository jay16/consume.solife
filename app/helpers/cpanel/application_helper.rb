module Cpanel::ApplicationHelper
  def cpanel_cache_key_for_view(objects, prefix="cpanel")
    cache_key_for_view(objects, prefix)
  end
end
