#encoding: utf-8
class Cpanel::UsersController < Cpanel::ApplicationController
  before_filter :find_user, only: [:show, :edit, :update, :destroy]


  def index
    @users = User.order("id desc").paginate :page => params[:page], :per_page => 15 
  end

  def show
  end

  def edit
  end

  def update
    @user.update_columns(user_params)

    info = "用户信息更新" + (@user ? "成功." : "失败.")
    redirect_to(edit_cpanel_user_path(@user.id), :notice => info)
  end

  def destroy
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name)
  end
end
