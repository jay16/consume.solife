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
          _head = datas[0..ps_title.length-2]
          _tail = datas[ps_title.length-1..-1]
          _head.push(_tail.join(" "))
        }.unshift(ps_title)
      end

      # find by pid
      def pid(pid)
        pid   = pid.to_s.strip
        list  = ::Ps::AUX.list
        title = list.shift
        index = title.index("PID")
        list.find_all { |datas|  datas.at(index) == pid }
      end
    end
  end
end
