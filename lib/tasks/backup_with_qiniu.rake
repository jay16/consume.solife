#encoding: utf-8
require "qiniu"
require "fileutils"

namespace :qiniu do
  def days_ago(num)
    now_i = Time.now.to_i
    ago_i = now_i - num*24*60*60
    Time.at(ago_i).strftime("%Y%m%d")
  end

  def bak_file_name(timestamp)
    "consume.db.bak.at.#{timestamp}.tar.gz"
  end

  def upload_file_2_qiniu(local_file)
    config = {
      :access_key => Setting.qiniu.access_key,
      :secret_key => Setting.qiniu.secret_key
    }
    bucket     = Setting.qiniu.bucket
    key        = File.basename(local_file)
    Qiniu.establish_connection!(config)

    put_policy = Qiniu::Auth::PutPolicy.new(bucket)
    uptoken = Qiniu::Auth.generate_uptoken(put_policy)

    code, result, response_headers = Qiniu::Storage.stat(bucket, key)
    if code == 200
      puts "[%s] already exist in [%s] then delete..." % [key, bucket]
      code, result, response_headers = Qiniu::Storage.delete(bucket, key)
      raise "Fail delete [%s] in [%s] with qiniu." % [key, bucket] if code != 200
    else
      puts "[%s] not found in [%s] then upload..." % [key, bucket]
    end

    code, result, response_headers = Qiniu::Storage.upload_with_put_policy(
        put_policy,
        local_file,
        key       # key
    )
    puts "[%s] upload successfully." % key
    return code == 200
  end

  task :download => :environment do
    bucket = Setting.qiniu.bucket
    key    = bak_file_name(days_ago(1))
    download_url = "http://%s.qiniudn.com/%s" % [bucket, key]

    tmp_file = Rails.root.join("tmp/%s" % key)
    File.delete(tmp_file) if File.exist?(tmp_file)

    curl_command = "curl -o %s %s" % [tmp_file, download_url]
    system(curl_command)

    # use `2>&1` then ruby variable will catch the output
    extract_command = "cd %s && tar -xvf %s 2>&1" % [Rails.root.join("tmp"), key]
    extract_file = `#{extract_command}`.split(/\s+/).last rescue nil
    if extract_file
      filepath = Rails.root.join("tmp", extract_file)
      rake_command = "bundle exec rake my_db:restore RAILS_ENV=production BACKUP_FILE=%s" % filepath
      `#{rake_command}`
      rake_command = "bundle exec rake db:migrate"
      `#{rake_command}`
    else
      puts "Error: fail download from qiniu."
    end
  end

  # backup database and upload to qiniu.
  task :upload => :environment do
    # database backup location.
    db_bak_path = "#{Rails.root}/db"
    raise "db_bak_path:#{db_bak_path}" unless File.exist?(db_bak_path)
    db_bak_path = File.join(db_bak_path, "db.bak")
    FileUtils.mkdir_p(db_bak_path)  unless File.exist?(db_bak_path)

    today_bak_file = bak_file_name(days_ago(0))
    tmp_sql_file   = "consume.db.bak.sql"
    # generate backup mysql script.
    puts shell_content = %Q{
      cd #{db_bak_path}                                    \n
      test -f #{tmp_sql_file} && rm -f #{tmp_sql_file}     \n
      test -f #{today_bak_file} && rm -f #{today_bak_file} \n
      mysqldump -u#{Setting.database.mysql.user} -p#{Setting.database.mysql.password} #{ Setting.database.mysql.dbname} > #{tmp_sql_file} \n
      tar -czvf #{today_bak_file} #{tmp_sql_file} && rm -f #{tmp_sql_file}
    }

    # execute backup mysql script.
    puts system(shell_content)

    today_bak_path = File.join(db_bak_path,today_bak_file)
    # raise when database's backup file not exist.
    raise "bak today's database fails!" unless File.exists?(today_bak_path)
    puts upload_file_2_qiniu(today_bak_path)
  end
end

desc "database operation."
namespace :db do
  # backup database and upload to qiniu.
  task :qiniu => :environment do
    rake_command = "bundle exec rake qiniu:upload"
    system(rake_command)
  end
end
