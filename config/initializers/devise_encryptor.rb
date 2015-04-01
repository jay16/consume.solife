require 'digest/md5'
require "base64"

module Devise
  module Encryptable
    module Encryptors
      class Md5 < Base
        def self.digest(password, stretches, salt, pepper)
          str = [password, salt].flatten.compact.join
          Digest::MD5.hexdigest(str)
        end
      end

      class MyEncryptor < Base
        def self.digest(password, stretches, salt, pepper)
          puts "*"*10
          puts "password: %s" % password.to_s
          puts "stretches: %s" % stretches.to_s
          puts "salt: %s" % salt.to_s
          puts "pepper: %s" % pepper.to_s
          puts "*"*10
          (1..5).each do |i| 
            password = password.strip.reverse if (i%2).odd?
            password = Base64.encode64(password).strip
          end
          return password
        end
      end
    end
  end
end
