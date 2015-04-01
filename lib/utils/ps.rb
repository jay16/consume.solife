module Ps
  PLATFORM = `uname -s`

  PS_COMMAND = case PLATFORM
  when "Darwin","Linux" then "ps aux"
  else "ps aux"
  end

  class AUX
    class << self
      def title
        ps_list  = `#{::Ps::PS_COMMAND}`.split("\n")
         ps_list.shift.upcase.split(/\s+/)
      end

      def list
        # %w[USER PID %CPU %MEM VSZ RSS TT STAT STARTED TIME COMMAND]
        ps_list  = `#{::Ps::PS_COMMAND}`.split("\n")
        ps_title = ps_list.shift.upcase.split(/\s+/)
        ps_list.map { |line|
          datas = line.split(/\s+/)
          hash  = {}
          hash[ps_title.last] = datas[ps_title.length-1..-1].join(" ")
          hash.merge Hash[[ps_title[0..-2], datas[0..ps_title.length-2]].transpose]
        }
      end

      # find by pid
      def pid(pid)
        pid   = pid.to_s.strip
        list  = ::Ps::AUX.list
        list.find_all { |hash|  hash["PID"] == pid }
      end
    end
  end
end

#puts Ps::AUX.pid($$)
