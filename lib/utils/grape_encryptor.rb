#encoding: utf-8
require "base64"

module Utils
  class GrapeEncryptor
    class << self
      def decode(token)
        str = Base64.decode64(token)
        n1 = str[0].to_i
        n2 = str[1..n1]
        str = str[n1+n2.length-1..str.length-1]

        e = str[0..n2.to_i-1]
        p = str[n2.to_i..str.length-1]
        [e, p]
      end

      def encode(e, p)
        n2 = e.length.to_s
        n1 = n2.length.to_s
        str = n1 + n2 + e + p
        Base64.encode64(str).strip
      end
    end
  end
end
