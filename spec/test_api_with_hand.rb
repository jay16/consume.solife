#encoding: utf-8
require "net/http"
require "uri"
require "json"

url  = "http://127.0.0.1"
port = 3000
base_url = [url, port].join(":")

def base_test_post base_url, path, params = {}
  uri = URI.parse(File.join(base_url, path))
  res = Net::HTTP.post_form(uri, params) 

  puts "=" * 10
  puts ["post", uri.to_s].join(" ")
  puts "测试结果:"
  puts res.code
  puts res.message
  puts res.body
end

def base_test_get base_url, path, params = {}
  uri = URI.parse(File.join(base_url, path))
  uri.query = URI.encode_www_form(params) if !params.empty?
  res = Net::HTTP.get(uri) #, {"accept-encoding" => "UTF-8"})

  puts "=" * 10
  puts ["get", uri.to_s].join(" ")
  puts "测试结果:"
  puts JSON.parse(res.is_a?(Net::HTTPSuccess) ? res.body : res).class
end


token = "MjIwc29saWZlLmpheUBnbWFpbC5jb21qYXk1MjcxMzA2NzM="
# test /api/users.json?token
#base_test_get(base_url, "/api/users", {format: "json", token: token})

# test /api/recores.json
#base_test_get(base_url, "/api/records", { format: "json", token: token})

# test /api/tags.json
#base_test_get(base_url, "/api/tags", { format: "json", token: token})


#    t.float    "value"
#    t.text     "remark"
#    t.string   "ymdhms"
#    t.integer  "klass"  # cloth/food/house/foot/other
record_param = { 
  record:  {
    value: rand(1000),
    ymdhms: Time.now.strftime("%Y/%m/%d %H:%M:%S").to_s,
    remark: "api" + rand(1000).to_s,
    "tags_list" => "hello, world",
    browser: "hello, world"
  }
}
token = "MjE2amF5X2xpQHNvbGlmZS51c2pheTUyNzEzMDY3Mw=="
param = { format: "json", token: token }.merge(record_param)
base_test_post(base_url, "/api/records", param)
base_test_post(base_url, "/api/records/558", param)

tag_param = {
  tag: {
    label: rand(100000).to_s,
    klass: rand(5),
    browser: "yes"
  }
}

param = { format: "json", token: token }.merge(tag_param)
base_test_post(base_url, "/api/tags", param)
base_test_post(base_url, "/api/tags/24", param)
#base_url = "http://consume.solife.us"
#token = "MjE2amF5X2xpQHNvbGlmZS51c2pheTUyNzEzMDY3Mw=="
param = { format: "json", token: token }.merge(record_param)
#base_test_post(base_url, "/api/records/9.json", param)
