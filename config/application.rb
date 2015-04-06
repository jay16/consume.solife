require File.expand_path('../boot', __FILE__)

require 'rails/all'
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Consume
  class Application < Rails::Application
    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += %W(#{config.root}/lib/utils)
    config.autoload_paths += %W(#{config.root}/app/grape)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    # don't generate RSpec tests for views and helpers
    config.generators do |g|
      # g.orm :active_record
      # g.template_engine :haml
      g.stylesheets false
      g.javascripts false
      #g.helper false
      g.view_specs false
      g.helper_specs false
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, :dir => "spac/factories"
    end

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = "Beijing"

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
     I18n.config.enforce_available_locales = true
     config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]
     config.i18n.locale = 'zh-CN'
     config.i18n.default_locale = 'zh-CN'


     # Configure the default encoding used in templates for Ruby 1.9.
     config.encoding = "utf-8"
     config.timeout_in = 20.minutes

     config.assets.enabled = true
     config.assets.version = '1.0'

     config.assets.precompile += %w(application.js records.js tags.js tag-it.js jquery.ui.js)
     config.assets.precompile += %w(application.css tag-it.css tag-it-theme.css)

     config.assets.paths << Rails.root.join("app", "assets", "fonts")
    # Configure sensitive parameters which will be filtered from the log file.
    #config.filter_parameters += [:password, :password_confirm, :token, :private_token]

    config.middleware.delete 'Rack::Cache'   # 整页缓存，用不上
    config.middleware.delete 'Rack::Lock'    # 多线程加锁，多进程模式下无意义
    config.middleware.delete 'ActionDispatch::RequestId' # 记录X-Request-Id（方便查看请求在群集中的哪台执行）
    config.middleware.delete 'ActionDispatch::RemoteIp'  # IP SpoofAttack
    config.middleware.delete 'ActionDispatch::Head'      # 如果是HEAD请求，按照GET请求执行，但是不返回body
    config.middleware.delete 'Rack::ConditionalGet'      # HTTP客户端缓存才会使用
    config.middleware.delete 'Rack::ETag'    # HTTP客户端缓存才会使用
    config.middleware.delete 'ActionDispatch::BestStandardsSupport' # 设置X-UA-Compatible, 在nginx上设置

    #config.middleware.delete 'Rack::Runtime' # 记录X-Runtime（方便客户端查看执行时间）
    #config.middleware.delete 'ActionDispatch::Callbacks' # 在请求前后设置callback
  end
end
