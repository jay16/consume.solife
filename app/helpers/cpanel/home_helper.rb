module Cpanel::HomeHelper
  def app_disk_info
    one   = `du -sh #{Rails.root}`.split.first
    two   = `du -sh #{Rails.root}/tmp`.split.first
    three = `du -sh #{Rails.root}/vendor`.split.first
    four  = `du -sh #{Rails.root}/log`.split.first
    "#{one}(vendor:#{three}, log:#{four}, tmp: #{two})"
  end

  def number_to_human_date(str)
    "%s%s/%s%s/%s%s" % str.chars.to_a
  end
  def number_to_human_time(str)
    "%s%s:%s%s.%s%s" % str.chars.to_a
  end
end
