require "base64"

# usage:
#
#  - encode
#  encode_password = Utils::Encryptor.encode(password)
#  
#  - decode
#  password = Utils::Encryptor.decode(encode_password)

module Utils
  module Encryptor
    class << self
      def encode(password)
        (1..5).each do |i| 
          password = password.strip.reverse if (i%2).odd?
          password = Base64.encode64(password).strip
        end
        return password
      end

      def decode(encrypt)
        (1..5).each do |i|
          encrypt = encrypt.strip.reverse if (i%2).even?
          encrypt = Base64.decode64(encrypt)
        end
        return encrypt.strip.reverse
      end
    end
  end
end
