class UsersController < ApplicationController
  respond_to :html, :js

  def index
    #@records = current_user.group_member_records
    @records = current_user.records
    @record  = current_user.records.new
    @record.ymdhms = Time.now.strftime("%Y-%m-%d %H:%M:%S") 
    @tags = current_user.tags

    fresh_when(:etag => [@records, @record, @members, @tags])
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
    # accept => false 等待被共享用户作出反应
    # 如果直接同意(post)，直接设置accept => true即可
    # 如果选择拒绝(delete)，则设置state => "refuse"
    # ask_group
    if request.get?
      # 如何确保存group{from_id, to_id}唯一？！
      @group = Group.find_by(to_id: params[:id])
      if @group
        @group.update({accept: false, state: "wait"})
      else
        @group = Group.create({from_id: current_user.id, to_id: params[:id], accept: false, state: "wait"})
      end
    # agree_group
    elsif request.post?
      @group = Group.find_by(from_id: params[:id])
      @group.update({accept: true, state: "accept"})
    # refuse_group
    elsif request.delete?
      @group = Group.find_by(from_id: params[:id])
      @group.update({accept: false, state: "refuse"})
    end

  end

end
