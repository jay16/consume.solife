module APIHelpers
  def current_user
    @current_user ||= User.validate(params[:token]) if params[:token]
  end 

  def authenticate!
    error!({ "error" => "401 Unauthorized" }, 401) unless current_user
  end 
end 
