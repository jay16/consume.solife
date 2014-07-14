# 爱记录 - 爱生活

....

## 启动

```` ruby
bunlde install
bunlde exec rake db:create
bunlde exec rake db:migrate
bundle exec rake assets:precompile RAILS_ENV=production
passenger start -e production
````
