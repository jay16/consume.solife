#Started GET "/assets/tag-it.css?body=1" for 127.0.0.1 at 2014-04-29 00:08:50 +0800
ip_lines = IO.readlines("./log/development.log").find_all(&/for\s(\d+\.\d+\.\d+\.\d+)/.method(:match))
path_lines = ip_lines.reject { |line| %w(.js .css).include? File.extname(line.split[2].split("?")[0]) } #移除js,css调用
uniq_path_lines = path_lines.map { |line| line.split[2] }.uniq.sort #uniq path lines
uniq_path_lines.map do |path| #path
  tmp_path_lines = path_lines.find_all { |line| line.include? path } #path lines
  tmp_ip_lines = tmp_path_lines.map { |line| line.split[4] }.uniq #ip lines
    .map { |ip| [ip, tmp_path_lines.find_all { |line| ip and line.include?(ip) }.count] } # [ip, count]
    .sort_by { |data| data[1] } #sort to get maxinum 
  [path, tmp_path_lines.count, tmp_ip_lines.last, tmp_path_lines.sort_by { |line| line.split[-3..-2].join(" ") }.last.split("for").last].flatten
end.each { |d| printf("%-30s%-10s%-20s%-10s%-35s\n", d[0], d[1], d[2], d[3], d[4]) } 
#path, "总访问次数", "访问最多的ip", "访问次数", "最后一次访问信息"
