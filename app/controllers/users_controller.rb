class UsersController < ApplicationController
  def index
    @records = current_user.records
    @record = current_user.records.new
    @record.ymdhms = Time.now.strftime("%Y-%m-%d %H:%M:%S") 
    @tags = current_user.tags
  end

  def show
  end

  def edit
  end

  def update
  end


end
