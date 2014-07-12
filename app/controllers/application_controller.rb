#encoding: utf-8
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def fresh_when(opts = {})
    opts[:etag] ||= []
    # 保证 etag 参数是 Array 类型
    opts[:etag] = [opts[:etag]] if !opts[:etag].is_a?(Array)
    # 加入页面上直接调用的信息用于组合 etag
    opts[:etag] << current_user
    # Config 的某些信息
   # opts[:etag] << SiteConfig.app_name
   # opts[:etag] << SiteConfig.custom_head_html
   # opts[:etag] << SiteConfig.footer_html
   # opts[:etag] << SiteConfig.google_analytics_key
    # 所有 etag 保持一天
    opts[:etag] << Date.current
    super(opts)
  end

  protected

=begin
    There are just three actions in Devise that allows any set of parameters to be passed down to the model, 
    therefore requiring sanitization. Their names and the permitted parameters by default are:
    
    sign_in (Devise::SessionsController#new) 
      - Permits only the authentication keys (like email)
    sign_up (Devise::RegistrationsController#create) 
      - Permits authentication keys plus password and password_confirmation
    account_update (Devise::RegistrationsController#update) 
      - Permits authentication keys plus password, password_confirmation and current_password
=end
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:account_update) << :name
  end
end
