class HomeController < ApplicationController
  def index
    @records = current_user.records
    @record = current_user.records.new
    @record.ymdhms = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end
end
