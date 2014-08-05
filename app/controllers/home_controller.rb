require "api"
class HomeController < ApplicationController
  skip_before_filter :authenticate_user!

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
  end
end
