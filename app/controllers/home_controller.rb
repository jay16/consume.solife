#encoding: utf-8
require "base"
class HomeController < ApplicationController
  protect_from_forgery except: :solife_post
  skip_before_filter :authenticate_user!
  # caches_page :root
  #caches_action :apis, expires_in: 1.day, unless_exist: true
  #caches_action :not_found, expires_in: 1.day, unless_exist: true

  def index
    if current_user.nil?
      @cache_list = Utils::ActionCache.list(20).reverse
      render layout: false
    else
      redirect_to "/users"
    end
  end

  def apis
    @routes = Consume::API::Base::routes
  end

  def solife_get
    respond_to do |format|
      format.text { render :text => params[:echostr] }
    end
  end

  def solife_post
    if user = User.find_by(email: params[:nToken])
      timestamp = Time.now.strftime("%Y-%m-%d %H:%M:%S")
      record = user.records.create({
        :value  => params[:nMoney] || 0,
        :remark => params[:nText],
        :ymdhms => timestamp
      })
      email = user.email.gsub(/(.*?)\@/) { "*"*$1.to_s.length+"@" }
      Utils::ActionCache.add([timestamp, email, "创建消费", params[:nMsgType] || "自来微信", request.ip])

      params = { uid: user.id, rid: record.id }
    end
    
    respond_to do |format|
      format.json { render :json => params.to_json }
    end
  end

  # Page 404
  def not_found
    respond_to do |format|
      format.all { render :file => "home/not_found.html", status: 404 } #, layout: false }
    end
  end
end
