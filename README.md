# 爱记录 - 爱生活

> 记录点滴生活, 爱生活, 爱记录

## 启动

```` ruby
bunlde install
bunlde exec rake db:create
bunlde exec rake db:migrate
bundle exec rake assets:precompile RAILS_ENV=production
passenger start -e production
````

# 更新日志

## 测试

+. 2014/07/20 sunday

  spec测试api#version/users/records/tags,不必在修改api时，写http模拟测试...

