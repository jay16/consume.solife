# 爱记录

> 记录点滴生活, 爱生活, 爱记录

## 启动/测试

```` ruby
bunlde install
bunlde exec rake db:create
bunlde exec rake db:migrate
bundle exec rake assets:precompile RAILS_ENV=production
passenger start -e production
````

```` ruby
bundle exec rake db:migrate RAILS_ENV=test
bundle exec rspec spec/grape
````

## TODO

  - [ ] devise邮箱验证rspec测试
  - [x] rails各种缓冲功能
  - [ ] 用户行为记录
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

