# [爱记录](http://consume.solife.us)

> 记录点滴生活, 爱生活, 爱记录

## 启动/测试

```` ruby
bunlde install
bunlde exec rake db:create
bunlde exec rake db:migrate
bundle exec rake assets:precompile RAILS_ENV=production
./unicorn.sh {start|stop|restart|force-reload|
````

```` ruby
bundle exec rake db:migrate RAILS_ENV=test
bundle exec rspec spec/grape
````

## Nginx Unciorn

````
  upstream consume-solife-unicorn {
      server unix:/home/work/consume/tmp/pids/unicorn.sock fail_timeout=0;
   }
   server {
      listen 80;
      server_name consume.solife.us iconsume.solife.us;
      root /home/work/consume/public;

      access_log /home/work/consume/log/nginx-access.log;
      error_log  /home/work/consume/log/nginx-error.log;
      location ~ ^/(assets)/ {
        gzip_static on;
        expires 1h;
        add_header Cache-Control public;
      }
      location / {
        try_files $uri @net;
      }
      location @net {
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header Host $http_host;
          proxy_redirect off;
          proxy_pass http://consume-solife-unicorn;
      }
    }
````

## TODO

  - [ ] devise邮箱验证rspec测试
  - [x] rails各种缓冲功能
  - [x] production运行环境 
  - [x] 用户行为记录
  - [ ] bug#搜索共享消费记录用户
  - [ ] bug#bootstrap navbar点击响应active
  - [ ] android客户端UI优化.
  - [ ] 普通界面spec测试.
  - [ ] ios客户端开发.


# 更新日志

+ 2014/07/20 Sunday

  1. spec测试api#grape,不必写http模拟测试.

+ 2014/07/26 Saturday

  1. 用户登陆后界面UI优化.
  2. 添加管理界面-管理员.
  3. will_paginate 视图helper配置在[I18.local](https://github.com/mislav/will_paginate/blob/master/lib/will_paginate/view_helpers.rb).

+ 2014/07/28 Monday

  1. 用户模型添加消费/标签的计算缓存(counter_cache).
  2. 消费/标签模型添加deleted字段用以同步状态至移动端.

+ 2014/07/30 Thursday

  1. 封装零散性功能代码.
  2. rspec测试不符合条件情况.
  3. devise自定义加密.

+ 2014/08/06 Wendnesday

  1. (视图缓存)[http://guides.rubyonrails.org/caching_with_rails.html]
  2. (sql缓存待做)

+ 2014/11/21 Friday

  1. 数据库备份同步至七牛

    ````
    bundle exec rake db:qiniu
    ````

  2. 使用`whenever`定时执行任务

    ````
    wheneverize .
    whenever -w
    whenever -c
    whenever --help
    ````

+ 2014/12/25 Thursday

    1. bug#api `Delete /api/records/id.json`

      abort when RecordNotFound

    2. tips#grape

      reload rails server when modify grape's code

    3. Gemfile.lock is needed.

      remote deploy on vps, `bundle install` will abort:

      > You are trying to install in deployment mode after changing your Gemfile. Run `bundle install` elsewhere and add the updated Gemfile.lock to version control.

      > If this is a development machine, remove the Gemfile freeze by running `bundle install --no-deployment`.

+ 2015/04/07 Tuesday

    1. rails运行环境调整为production

      [rails设置](http://guides.rubyonrails.org/asset_pipeline.html)及[nginx配置](https://ruby-china.org/topics/201)

+ 2015/04/08 Wednesday

    1. bug#fix api 

      ````
      # route
      Get /api/records.json
      # undefine method - undeleted
      current_user.records.undeleted
      # model - record.rb
      scope :undeleted, -> { where(:deleted != true) }
      ````

    2. logger format

      ````
      # config/evironment.rb file bottom add:
      class Logger  
        def format_message(level, time, progname, msg)  
          "%s, [%s] -- %s\n" % [level[0], time.to_s(:db), msg]
        end  
      end  
      ````
+ 2015/05/04 Monday

    1. add#user_report

    2. rspec run a single test

      Where 133 represents the line of the test I want to run.

      ````
      bundle exec rspec spec/grape/v1/records_spec.rb:133
      ````

      [stackoverflow](http://stackoverflow.com/questions/6116668/rspec-how-to-run-a-single-test)

+ 2015/05/17

    use gem#cancancan manage resource authorization.

