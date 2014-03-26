class HomeController < ApplicationController
  def index
    @records = current_user.records
    @record = current_user.records.new
  end
end
