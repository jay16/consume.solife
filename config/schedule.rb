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
set :output, {:error => 'whenever.error', :standard => 'whenever.standard'}
every 1.day, :at => "11:59 pm"  do
  rake "db:qiniu"
end
