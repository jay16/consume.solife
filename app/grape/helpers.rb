module APIHelpers

  # customer logger
  def logger
      Consume::API.logger
  end
  
  def current_user
    return false unless params[:token]
    #@current_user = JSON.parse(cookies[params[:token].to_sym]) if cookies[params[:token].to_sym]
    @current_user ||= User.validate(params[:token])
    #cookies[params[:token].to_sym] =  { value: @current_user.to_json, expires: 1.days.from_now }
  end 

  def authenticate!
    error!({ "error" => "401 Unauthorized" }, 401) unless current_user
  end 

  # params[:record] should hash
  # but get string
  def must_be_hash(hstr)
    hstr.is_a?(String) ? eval(hstr) : hstr
  end

  def extract_tags_list(params)
    params.delete(:tags_list) { |e| "" }
  end

  def browser_with_ip
    #browser   = request.env["HTTP_USER_AGENT"] || request.user_agent
    remote_ip = request.env['REMOTE_ADDR'] || request.remote_ip
    return { :ip => remote_ip }
  end
end 
