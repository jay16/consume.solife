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

  4. bug#搜索共享消费记录用户
  5. bug#bootstrap navbar点击响应active
  3. android客户端UI优化.
  4. 普通界面spec测试.
  5. ios客户端开发.


# 更新日志

+ 2014/07/20 sunday

  1. spec测试api#grape,不必写http模拟测试.

+ 2014/07/26 starday

  1. 用户登陆后界面UI优化.
  2. 添加管理界面-管理员.
  3. will_paginate 视图helper配置在[I18.local](https://github.com/mislav/will_paginate/blob/master/lib/will_paginate/view_helpers.rb).

+ 2014/07/28 monday

  1. 用户模型添加消费/标签的计算缓存(counter_cache).
  2. 消费/标签模型添加deleted字段用以同步状态至移动端.
