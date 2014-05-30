require "#{Dir.pwd}/my_rest.rb"
require "uri"
require "net/http"

token = "MjIwc29saWZlLmpheUBnbWFpbC5jb21qYXk1MjcxMzA2NzM="

token = "MjE2amF5X2xpQHNvbGlmZS51c2pheTUyNzEzMDY3Mw=="
url = "http://localhost:3000/api/records/1.json?token=#{token}"
uri = URI.parse(url)
http = Net::HTTP.start(uri.host, uri.port)
resp = http.send_request('DELETE', uri.request_uri)
puts resp.code
puts resp.message
puts resp.body

