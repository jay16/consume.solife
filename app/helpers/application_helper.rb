#encoding: utf-8
require "uri"
require "open-uri"
require "fileutils"
module ApplicationHelper

  def render_page_title
    site_name = Setting.title
    title = @page_title ? "#{site_name} | #{@page_title}" : site_name rescue "SITE_NAME"
    content_tag("title", title, nil, false)

  end

  def gravatar_image_cache_tag(email, alt="")
    url = gravatar_image_url(email, alt: alt)
    uri = URI.parse(url)
    gravatar_id = uri.path.split(/\//).last rescue "default"
    gravatar_name =  "%s.jpg" % gravatar_id
    gravatar_relative_path = "assets/images/gravatar/" + gravatar_name
    gravatar_absolute_path = Rails.root.join("public", gravatar_relative_path)
    if File.exist?(gravatar_absolute_path)
      image_tag "/" + gravatar_relative_path, alt
    else
      gravatar_dirname = File.dirname(gravatar_absolute_path)
      FileUtils.mkdir_p(gravatar_dirname) unless File.exist?(gravatar_dirname)
      begin
        File.open(gravatar_absolute_path, "w+") do |file|
          file.puts open(url) { |f| f.read }.force_encoding("UTF-8")
        end
        image_tag "/" + gravatar_relative_path, alt
      rescue
        image_tag url
      end
    end
  end

  def controller_stylesheet_link_tag
    fname = case controller_name
    when "users"
      fname = "#{controller_name}.css"
    else ""  
    end

    return "" if fname.blank?
    raw %(<link href="#{asset_path(fname)}" rel="stylesheet" data-turbolinks-track />)
  end

  def controller_javascript_include_tag
    fname = case controller_name
    when "users"
      fname = "#{controller_name}.js"
    else ""
    end

    return "" if fname.blank?
    raw %(<script src="#{asset_path(fname)}" data-turbolinks-track></script>)
  end

  # flash notice
  def notice_message
    flashs = flash.reject { |t, m| t.empty? }

    flashs.map do |type, message|
      next if message.to_s == "true"
      content_tag(:div, link_to("x", "#", class: "close", "data-dismiss" => "alert") + message, class: "alert alert-#{type == :notice ? :success : :warning}")
    end.join("\n").html_safe unless flashs.empty?
  end

  def controller_javascript_include_tag
  end

  # judge client whether is mobile and tell mobile type
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

  # generate view cache key
  def cache_key_for_view(objects, prefix = "current_user")
    klass = objects.class.to_s.downcase.split(/_/).reverse.first #ActiveRecord::Relation::ActiveRecord_Relation_Tag
    size  = objects.size
    keystamp = size.zero? ? 0 : objects.map(&:updated_at).max.try(:utc).try(:to_s, :number)
    "#{prefix}/#{klass}-#{size}-#{keystamp}"
  end
end
