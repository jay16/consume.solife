lines = IO.readlines("./log/development.log")
ip_lines = lines.find_all { |line| line =~ /\d+\.\d+\.\d+\.\d+/ }
path_lines = ip_lines.reject { |line| %w(.js .css).include? File.extname(line.split[2].split("?")[0]) }
uniq_path_lines = path_lines.map { |line| line.split[2] }.uniq.sort
datas = uniq_path_lines.map do |path|
  tmp_path_lines = path_lines.find_all { |line| line.include? path }
  tmp_path_lines1 = tmp_path_lines.clone
  tmp_ip_lines = tmp_path_lines.map { |line| line.split[4] }.uniq.map do |ip|
    [ip, tmp_path_lines1.find_all { |line| ip and line.include?(ip) }.count]
  end.sort_by { |data| data[1] }
  [path, tmp_path_lines.count, tmp_ip_lines[0]]
end

datas.each do |data|
  puts data.flatten.join(" ")
end

