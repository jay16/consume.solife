#encoding: utf-8
require "api"
class HomeController < ApplicationController
  skip_before_filter :authenticate_user!
  # caches_page :root
  caches_action :api

  def index
    if current_user.nil?
      @cache_list = Utils::ActionCache.list(20).reverse
      render layout: false
    else
      redirect_to "/users"
    end
  end

  def api
    @routes = Consume::API::routes
    @page_title = "api列表"
  end
end
