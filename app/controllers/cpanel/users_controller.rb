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
    statu = @user.update_columns(user_params)

    notice = "用户信息更新" + (statu ? "成功." : "失败.")
    redirect_to(edit_cpanel_user_path(@user.id), :notice => notice)
  end

  def destroy
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :gender, :address).merge({ updated_at: DateTime.now })
  end
end
