#encoding: utf-8
require "fileutils"

def days_ago(num)
  now_i = Time.now.to_i
  ago_i = now_i - num*24*60*60
  Time.at(ago_i).strftime("%Y%m%d")
end

def bak_file_name(timestamp)
  "consume.db.bak.at.#{timestamp}.tar.gz"
end

task :hello => :environment do
  #数据库备份位置
  db_bak_path = "#{Rails.root}/db"
  raise "db_bak_path:#{db_bak_path}" unless File.exist?(db_bak_path)
  db_bak_path = File.join(db_bak_path, "db.bak")
  FileUtils.mkdir_p(db_bak_path)  unless File.exist?(db_bak_path)

  today_bak_file = bak_file_name(days_ago(0))

  #生成shell脚本，备份数据库
  shell_content = %Q(
    cd #{db_bak_path}                                      \n
    mysqldump -u#{Setting.database.mysql.user} -p#{Setting.database.mysql.password} #{ Setting.database.mysql.dbname} > consume.db.bak.sql \n
    tar -czvf #{today_bak_file} consume.db.bak.sql          \n
    rm -f consume.db.bak.sql                                \n
    )

  puts shell_content
  #执行shell脚本
  puts system("#{shell_content}")

  today_bak_path = File.join(db_bak_path,today_bak_file)

  #备份今天的数据库失败，则终止后续操作
  raise "bak today's database fails!" unless File.exists?(today_bak_path)
end
