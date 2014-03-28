json.array!(@records) do |record|
  json.extract! record, :id, :user_id, :value, :remark, :ymdhms
  json.url record_url(record, format: :json)
end
