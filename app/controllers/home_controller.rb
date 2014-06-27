require "api"
class HomeController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    cache_list = File.join(Rails.root, "tmp/api_cache.list")
    @cache = IO.readlines(cache_list).last(50)
    render layout: false
  end

  def api
    @routes = Consume::API::routes
  end
end
