module Cpanel::RecordsHelper
  def cpanel_cache_key_for_record(records)
    size = records.size
    keystamp = size.zero? ? 0 : records.first.updated_at.try(:utc).try(:to_s, :number)
    "cpanel/records/paginate-#{size}-#{keystamp}"
  end
end
