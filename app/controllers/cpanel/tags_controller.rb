class Cpanel::TagsController < Cpanel::ApplicationController
  def index
    @tags = Tag.order("id desc").paginate :page => params[:page], :per_page => 15
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
