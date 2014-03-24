class UsersController < ApplicationController
  def index
    redirect_to user_path(current_user)
  end

  def show
  end

  def edit
  end

  def update
  end


end
