class Cpanel::CommentsController <  Cpanel::ApplicationController
  def index
    @comments = Comment.order("id desc").paginate :page => params[:page], :per_page => 20
  end

  def show
  end

  def edit
  end

  def updatd
  end

  def destroy
  end
end
