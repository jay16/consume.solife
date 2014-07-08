require "api"
class HomeController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    if current_user.nil?
      cache_list = File.join(Rails.root, "tmp/api_cache.list")
      @cache = IO.readlines(cache_list).last(20)
      render layout: false
    else
      redirect_to "/users"
    end
  end

  def api
    @routes = Consume::API::routes
  end
end
