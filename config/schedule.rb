# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
#set :output, "/path/to/my/cron_log.log"
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end
# Learn more: http://github.com/javan/whenever
#
#
#https://github.com/javan/whenever/wiki/Output-redirection-aka-logging-your-cron-jobs
#set :output, {:error => 'log/whenever.error', :standard => 'log/whenever.standard'}

# 默认:command命令，在全局执行linux bash command
# 但写在app内的脚本，都假设进入应用root目录下了
job_type :command_within_app, "cd :path && :task :output"

every 1.day, :at => "11:59 pm" do
	# 备份数据库，并把压缩文件上传于七牛服务器 
    rake "db:qiniu >> log/db-qiniu.log 2>&1"

    # 切割rails logger文件，并使用log-analyzer gem进行分析
	command_within_app "/bin/bash unicorn.sh log-analyzer production >> log/log-analyzer.log 2>&1"
end


# 定时清空缓存，需要使用linux root权限
every 1.hour do
	command "sync && echo 3 > /proc/sys/vm/drop_caches"
end