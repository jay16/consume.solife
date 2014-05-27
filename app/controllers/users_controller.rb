class UsersController < ApplicationController
  respond_to :html, :js

  def index
    @records = current_user.records
    @record  = current_user.records.new
    @members = User.members(current_user)
    @record.ymdhms = Time.now.strftime("%Y-%m-%d %H:%M:%S") 
    @tags = current_user.tags
  end

  def show
  end

  def edit
  end

  def update
  end

  def search
    q = "%#{params[:keyword]}%"
    @users = User.where("email like ? or name like ?", q, q)
  end

  def group
    Group.create({
      :from_id => current_user.id,
      :to_id   => params[:id],
      :state   => false
    })
  end

end
