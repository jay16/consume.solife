module SysInfo
  PLATFORM = `uname -s`.strip

  PS_COMMAND = case PLATFORM
  when "Darwin","Linux" then "ps aux"
  else "ps aux"
  end

  class Base
    class << self
      def hash 
        case SysInfo::PLATFORM
        when "Darwin"
          { :hostname   => `/bin/hostname`.strip,
            :ip          => `ifconfig | sed -n -e '/inet6/d' -e '/broadcast/p' | awk '{ print $2 }'`.strip,
            :kernal_name => `uname -v | cut -d : -f 1`.strip,
            :platform   => `uname -v | cut -d : -f 1`.strip,
            :hardware    => `uname -m`.strip,
            :timezone    => `date`.strip.scan(/\+\d{4}/)[0],
            :memory      => (`top -l 1 | head -n 10 | grep PhysMem`.scan(/(\d+)M/).flatten.map(&:to_i).reduce(:+)/1024).to_s + "G",
            :cpu         => "TODO",
            :disk        => (`top -l 1 | grep Disks`.scan(/(\d+)\/\d+M written/).flatten[0].to_i/1024).to_s+"G"
          }
        when "Linux"
            mem_total = IO.read("/proc/meminfo").scan(/MemTotal:\s+(\d+)\skB/)[0][0] rescue "-1"
          { :hostname    => `/bin/hostname`.strip,
            :ip          => `ifconfig|sed -n -e '/inet6/d' -e '/Bcast/p'|cut -d : -f 2|awk '{print $1}'`.strip,
            :kernal_name => `uname -o`.strip,
            :plantform   => `cat /etc/issue | head -n 1`.strip,
            :hardware    => `uname -m`.strip,
            :timezone    => `date -R`.strip.scan(/\+\d{4}/)[0],
            :memory      => eval("(%s.0/1024/1024+0.5).to_i" % mem_total) +"G",
            :cpu         => `cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c`,
            :disk        => `df -h | grep "/dev/" | head -n 1`.split(/\s+/)[1]
          }
        else {"is" => SysInfo::PLATFORM }
        end
      end
    end
  end

  class Ps
    class << self
      def title
        ps_list  = `#{::SysInfo::PS_COMMAND}`.split("\n")
         ps_list.shift.upcase.split(/\s+/)
      end

      def list
        # %w[USER PID %CPU %MEM VSZ RSS TT STAT STARTED TIME COMMAND]
        ps_list  = `#{::SysInfo::PS_COMMAND}`.split("\n")
        ps_title = ps_list.shift.upcase.split(/\s+/)
        ps_list.map { |line|
          datas = line.split(/\s+/)
          hash = Hash[[ps_title[0..-2], datas[0..ps_title.length-2]].transpose]
          hash[ps_title.last] = datas[ps_title.length-1..-1].join(" ")
          hash["START"]   ||= hash["STARTED"] # Darwin - STARTED
          hash["STARTED"] ||= hash["START"]   # Linux  - START
          hash
        }
      end

      # find by pid
      def pid(pid)
        pid   = pid.to_s.strip
        list  = ::SysInfo::Ps.list
        list.find_all { |hash|  hash["PID"] == pid }
      end
    end
  end
end

#puts SysInfo::Ps.pid($$)
#puts SysInfo::Base.hash
