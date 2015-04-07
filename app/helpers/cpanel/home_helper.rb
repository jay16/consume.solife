module Cpanel::HomeHelper
  def app_disk_info
    `du -sh #{Rails.root}`.split.first
  end
end
