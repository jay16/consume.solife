module APIHelpers

  # customer logger
  def logger
    #Consume::API.logger
    Rails.logger
  end
  
  def current_user
    token = (params[:token] || "").to_s.strip
    return false if !@current_user && token.empty?
    @current_user ||= User.validate(token)
  end 

  def authenticate!
    error!({ :error => "401 Unauthorized" }, 401) unless current_user
  end 

  # params[:record] should hash
  # but get string
  def must_be_hash(hstr)
    hash = hstr.is_a?(String) ? eval(hstr) : hstr
    new_hash = Hash.new
    hash.each_pair { |k, v| new_hash[k.to_sym] = v }
    return new_hash
  end

  def extract_tags_list(params)
    params.delete(:tags_list) { |e| "" }
  end

  def browser_with_ip
    #browser   = request.env["HTTP_USER_AGENT"] || request.user_agent
    remote_ip = request.env['REMOTE_ADDR'] || request.remote_ip
    return { :ip => remote_ip }
  end

  def add_create_cache(arr)
    Utils::ActionCache.add(arr)
  end
end 
