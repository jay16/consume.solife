require 'rubygems'
require 'net/http'
module MyREST
    def self.get(url)
        uri = URI.parse(url)
        http = Net::HTTP.start(uri.host, uri.port)
        resp = http.send_request('GET', uri.request_uri)
        resp.body
    end
 
    def self.post(url, data, content_type)
        uri = URI.parse(url)
        http = Net::HTTP.start(uri.host, uri.port)
        http.send_request('POST', uri.request_uri, data, 'Content-Type' => content_type)
    end
 
    def self.put(url, data, content_type)
        uri = URI.parse(url)
        http = Net::HTTP.start(uri.host, uri.port)
        http.send_request('PUT', uri.request_uri, data, 'Content-Type' => content_type)
    end
 
    def self.delete(url)
        uri = URI.parse(url)
        http = Net::HTTP.start(uri.host, uri.port)
        http.send_request('DELETE', uri.request_uri)
    end
 
end
