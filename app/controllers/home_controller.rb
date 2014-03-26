class HomeController < ApplicationController
  def index
    @record = current_user.records.new
  end
end
