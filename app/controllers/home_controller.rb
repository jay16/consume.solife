require "api"
class HomeController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
  end

  def api
    @routes = Consume::API::routes
  end
end
