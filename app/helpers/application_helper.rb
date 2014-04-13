#encoding: utf-8
module ApplicationHelper

  def render_page_title
    content_tag(:title, "爱记录,爱生活", nil, false)
  end

  def controller_stylesheet_link_tag
    case controller_name
    when "home","contacts","sms"
      #stylesheet_link_tag "https://land.xiaomi.net/res/c9369bd/css/micloudfe/home.css"
    end
  end

  def notice_message
    flashs = flash.reject { |t, m| t.empty? }
    flashs.map do |type, message|
      content_tag(:div, link_to("x", "#", class: "close", "data-dismiss" => "alert") + message, class: "alert alert-#{type == :notice ? :success : :warning}")
    end.join("\n").html_safe if !flashs.empty?
  end

  def controller_javascript_include_tag
  end

  MOBILE_USER_AGENTS =  'palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|' +
                        'audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|' +
                        'x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|' +
                        'pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|' +
                        'webos|amoi|novarra|cdm|alcatel|pocket|iphone|mobileexplorer|mobile'
  def mobile?
    agent_str = request.user_agent.to_s.downcase
    return false if agent_str =~ /ipad/
    agent_str =~ Regexp.new(MOBILE_USER_AGENTS)
  end

  
end
