#encoding: utf-8
module SysInfo
  PLATFORM = `uname -s`.strip

  PS_COMMAND, TOP_COMMAND = case PLATFORM
  when "Darwin" then ["ps aux", "top -l 1 | head -n 10"]
  when "Linux"  then ["ps aux", "top -b -n 1 | head -n 5"]
  end

  class Top
    class << self
      def hash_and_array
        [SysInfo::Top.hash, SysInfo::Top.array]
      end

      def array
        title, result = [], []
        case SysInfo::PLATFORM
        when "Darwin"
          title << %w(系统时间 系统负载)
          title << %w(所有 运行 僵尸 睡眠 线程)
          title << %w(用户空格 内核空间 空闲)
          title << %w(已使用 Wired 未使用)
          title << %w(读取 写入)
          title << %w(In Out)
          klass = %w(Top 进程 CPU 内存 硬盘 网络)
        when "Linux"
          title << %w(系统时间 已运行 用户数 系统负载)
          title << %w(所有 运行 睡眠 停止 僵尸)
          title << %w(用户空间 内核空间 用户进程 空闲 等待 hi si st)
          title << %w(所有 已使用 空闲 缓冲)
          title << %w(所有 已使用 空闲 缓冲)
          klass = %w(Top 进程 CPU 内存 Swap)
        end
        max_len = title.sort { |x, y| y.length <=> x.length }.first.length
        SysInfo::Top.base.each_with_index do |data, index|
          row = [title[index], data].transpose.flatten.unshift(klass[index])
          row += Array.new(max_len*2 - row.length, nil) if row.length < max_len*2
          result << row
        end
        return result
      end

      def hash
        title, result = [], {}
        case SysInfo::PLATFORM
        when "Darwin"
          title << %w(systime loadaverage)
          title << %w(total running stuck sleeping threads)
          title << %w(user sys idle)
          title << %w(used wired unused)
          title << %w(read written)
          title << %w(in out)
          klass = %w(top processes cpu mem disk network)
        when "Linux"
          title << %w(systime runtime user loadaverage)
          title << %w(total running sleeping stopped zombie)
          title << %w(us sy ni id wa hi si st)
          title << %w(total used free buffers)
          title << %w(total used free cached)
          klass = %w(top tasks cpu mem swap)
        end
        SysInfo::Top.base.each_with_index do |data, index|
          result[klass[index]] =  [title[index], data].transpose
        end
        return result
      end
      def base
        str = `#{TOP_COMMAND}`
        array = []
        case SysInfo::PLATFORM
        when "Darwin"
          #str = "Processes: 170 total, 2 running, 5 stuck, 163 sleeping, 802 threads
          #      2015/04/07 22:16:40
          #      Load Avg: 1.55, 1.46, 1.48
          #      CPU usage: 5.71% user, 25.71% sys, 68.57% idle
          #      SharedLibs: 12M resident, 16M data, 0B linkedit.
          #      MemRegions: 33503 total, 2947M resident, 110M private, 664M shared.
          #      PhysMem: 5276M used (851M wired), 2914M unused.
          #      VM: 432G vsize, 1065M framework vsize, 0(0) swapins, 0(0) swapouts.
          #      Networks: packets: 32430/25M in, 36209/4765K out.
          #      Disks: 54518/1984M read, 113947/2633M written."
          array << str.scan(/(\d{4}\/\d{2}\/\d{2}\s\d{2}:\d{2}:\d{2})\n\s*Load\sAvg:\s+(.*?)\n/)[0]
          array << str.scan(/Processes:\s(\d+)\stotal,\s(\d+)\srunning,\s(\d+)\sstuck,\s(\d+)\ssleeping,\s(\d+)\sthreads/)[0]
          array << str.scan(/CPU\susage:\s(.*?)\suser,\s(.*?)\ssys,\s(.*?)\sidle/)[0]
          array << str.scan(/PhysMem:\s(.*?)\sused\s\((.*?)\swired\),\s(.*?)\sunused/)[0]
          array << str.scan(/Disks:\s(.*?)\sread,\s(.*?)\swritten/)[0]
          array << str.scan(/Networks:\spackets:\s(.*?)\sin,\s(.*?)\sout/)[0]
        when "Linux"
          #str = "top - 11:43:29 up 31 days, 11:29,  1 user,  load average: 0.19, 0.07, 0.01
          #       Tasks:  84 total,   1 running,  83 sleeping,   0 stopped,   0 zombie
          #       Cpu(s):  0.6%us,  0.5%sy,  0.1%ni, 98.8%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
          #       Mem:   1026136k total,   875180k used,   150956k free,   138500k buffers
          #       Swap:        0k total,        0k used,        0k free,   202784k cached"
          str = " 
top - 23:38:09 up 31 days, 23:24,  1 user,  load average: 0.39, 0.13, 0.08
Tasks:  81 total,   1 running,  80 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.6%us,  0.5%sy,  0.1%ni, 98.8%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   1026136k total,   862524k used,   163612k free,   144116k buffers
Swap:        0k total,        0k used,        0k free,   212756k cached
          "
          array << str.scan(/top\s+-\s+(\d{2}:\d{2}:\d{2})\s+up\s+(\d+\s+days,\s+\d{2}:\d{2}),\s+(\d+)\suser,\s+load\saverage:\s+(.*?)\n/)[0]
          array << str.scan(/Tasks:\s+(\d+)\stotal,\s+(\d+)\srunning,\s+(\d+)\ssleeping,\s+(\d+)\sstopped,\s+(\d+)\szombie/)[0]
          array << str.scan(/Cpu\(s\):\s+(.*?)%us,\s+(.*?)%sy,\s+(.*?)%ni,\s+(.*?)%id,\s+(.*?)%wa,\s+(.*?)%hi,\s+(.*?)%si,\s+(.*?)%st/)[0]
          array << str.scan(/Mem:\s+(\d+k)\stotal,\s+(\d+k)\sused,\s+(\d+k)\sfree,\s+(\d+k)\sbuffers/)[0]
          array << str.scan(/Swap:\s+(\d+k)\stotal,\s+(\d+k)\sused,\s+(\d+k)\sfree,\s+(\d+k)\scached/)[0]
        end
        return array
      end
    end
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
            mem_free  = IO.read("/proc/meminfo").scan(/MemFree:\s+(\d+)\skB/)[0][0] rescue "-1"
          { :hostname    => `/bin/hostname`.strip,
            :ip          => `ifconfig|sed -n -e '/inet6/d' -e '/Bcast/p'|cut -d : -f 2|awk '{print $1}'`.strip,
            :kernal_name => `uname -o`.strip,
            :platform   => `cat /etc/issue | head -n 1`.strip,
            :hardware    => `uname -m`.strip,
            :timezone    => `date -R`.strip.scan(/\+\d{4}/)[0],
            :memory      => eval("(%s.0/1024/1024+0.5).to_i" % mem_total).to_s + "G",
            :mem_free    => eval("(%s.0/1024/1024+0.5).to_i" % mem_free).to_s + "G",
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
#puts SysInfo::Top.array.to_s
#puts SysInfo::Top.hash.to_s
#puts SysInfo::Top.array.to_s
