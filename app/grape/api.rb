#encoding: utf-8
require "entities"
require "helpers"
require "json"
class Consume::API < Grape::API
  #version "v1"
  prefix "api"
  format :json
  default_format :json
  default_error_formatter :json

  helpers APIHelpers

  rescue_from :all do |e|
    case e
    when ActiveRecord::RecordNotFound
      Rack::Response.new(["user not found"], 404, {}).finish
    when Mysql2::Error
      Rack::Response.new(["Mysql2::Error"], 402, {}).finish
    else
      Rails.logger.error "APIv1 Error: #{e}\n#{e.backtrace.join("\n")}"
      Rack::Response.new(['error'], 500, {}).finish
    end
  end

  # logger params for all api
  before do
    logger.info "Params:\n#{params.to_json}"

    if current_user
      @cache_arr = []
      @cache_arr.push(Time.now.strftime("%Y-%m-%d %H:%M:%S"))
      @cache_arr.push(current_user.email.gsub(/(.*?)\@/) { "*"*$1.to_s.length+"@" })
    end
  end

  # get /api/routes
  desc "consume::api routes"
  get "/routes" do
    Consume::API::routes.map{ |i| {desc: i.route_description, method: i.route_method, path: i.route_path} }.to_json 
  end

  # get /api/versions
  desc "android/ios client version"
  get "/version" do
    case params[:os].to_s
    when "android" then
      { 
        :version     => Setting.mobile.os.android.version,
        :apk_name    => File.basename(Setting.mobile.os.android.url),
        :describtion => Setting.mobile.os.android.describtion, 
        :url         => Setting.mobile.os.android.url 
      }
    else
        error! "#{params[:os]} should in [android]", 404
    end
  end

  # validation user for below api
  #before_validation do
  #  authenticate!
  #end
  resource :users do
    # get /api/users.json?token=abc
    desc "get user info with token."
    get do
      authenticate!
      present current_user, with: APIEntities::User
    end

    # get /api/users/friends.json
    desc "get group members"
    get "/friends" do
      authenticate!
      users = current_user.group_members
      users.reject!{ |u| params[:ids].split(",").include?(u.id.to_s) } if params[:ids] and !params[:ids].empty?
      present users, with: APIEntities::User
    end

    # put /api/users.json?name=new_name
    desc "update user info."
    post do
      authenticate!
      current_user.update(params[:user])

      @cache_arr.push("更新个人信息")
      @cache_arr.push("api")
      @cache_arr.push(browser_with_ip[:ip])
      add_create_cache(@cache_arr)
      present current_user, with: APIEntities::User
    end
  end
 
  # core object [records]
  resource :records do
    # get /api/records.json
    desc "get record list."
    get do
      authenticate!
      if !params[:updated_at].nil?
        condition = %Q(date_format(updated_at,'%Y-%m-%d %H:%i:%s') > '#{params[:updated_at]}')
      else
        condition = %Q(id > #{params[:id] || 0}) 
      end
      records = current_user.records.undeleted.where(condition) 
      present records, with: APIEntities::Record
    end

    # get records of user's friends
    # get /api/records/friends.json
    get "/friends" do
      authenticate!
      if !params[:updated_at].nil?
        condition = %Q(date_format(updated_at,'%Y-%m-%d %H:%i:%s') > '#{params[:updated_at]}')
      else
        condition = %Q(id > #{params[:id] || 0}) 
      end
      records = current_user.group_member_records(false).where(condition) 
      present records, with: APIEntities::Record
    end

    # post /api/records.json
    desc "create a new record."
    post do
      authenticate!
      # force params to hash 
      # browse/ip be covered by params when params include browser/ip
      record_params = must_be_hash(params[:record]).merge(browser_with_ip)
      # delete the virtus attribute [.tags_list] from params
      tags_list = extract_tags_list(record_params)
      record = current_user.records.where(record_params).first_or_create
      # build relation with tags
      record.tags_list = tags_list
      record.build_relation_with_tags

      @cache_arr.push("创建消费")
      @cache_arr.push(record.browser)
      @cache_arr.push(record.ip)
      add_create_cache(@cache_arr)
      present record, with: APIEntities::Record
    end

    # get /api/records/1.json
    desc "get a record."
    get "/:id" do
      authenticate!
      record = current_user.records.undeleted.find(params[:id])
      present record, with: APIEntities::Record
    end

    # put /api/recores/1.json
    desc "update a record."
    post "/:id" do
      authenticate!
      record = current_user.records.find(params[:id])
      record_params = must_be_hash(params[:record]).merge(browser_with_ip)
      record.update(record_params)

      @cache_arr.push("修改消费")
      @cache_arr.push(record.browser)
      @cache_arr.push(record.ip)
      add_create_cache(@cache_arr)
      present record, with: APIEntities::Record
    end

    # delete /api/recores/1.json
    desc "delete a record."
    delete "/:id" do
      authenticate!
      begin
        record = current_user.records.undeleted.find(params[:id])
        record.soft_delete
      rescue => e
        puts e.message
        record = current_user.records.last
      end
      present record, with: APIEntities::Record
    end
  end

  resource :tags do
    # get /api/tags.json
    desc "get tag list."
    get do
      authenticate!
      if !params[:updated_at].nil?
        condition = %Q(date_format(updated_at,'%Y-%m-%d %H:%i:%s') > '#{params[:updated_at]}')
      else
        condition = %Q(id > #{params[:id] || 0}) 
      end
      tags = current_user.tags.undeleted.where(condition) 
      present tags, with: APIEntities::Tag
    end

    # get /api/tags.json
    desc "get a tag."
    get "/:id" do
      authenticate!
      tag = current_user.tags.find(params[:id])
      present tag, with: APIEntities::Tag
    end

    # post /api/tags.json
    desc "create a new tag."
    post do
      authenticate!
      tag_params = must_be_hash(params[:tag]).merge(browser_with_ip)
      tag = current_user.tags.where(tag_params).first_or_create

      @cache_arr.push("创建标签")
      @cache_arr.push(tag.browser)
      @cache_arr.push(tag.ip)
      add_create_cache(@cache_arr)
      present tag, with: APIEntities::Tag
    end

    # post /api/tags.json
    desc "update a tag."
    post "/:id" do
      authenticate!
      tag = current_user.tags.undeleted.find(params[:id])
      tag_params = must_be_hash(params[:tag]).merge(browser_with_ip)
      tag.update(tag_params)

      @cache_arr.push("修改标签")
      @cache_arr.push(tag.browser)
      @cache_arr.push(tag.ip)
      add_create_cache(@cache_arr)
      present tag, with: APIEntities::Tag
    end

    # delete /api/tags/1.json
    desc "delete a tag."
    delete "/:id" do
      authenticate!
      tag = current_user.tags.undeleted.find(params[:id])
      tag.soft_delete
      present tag, with: APIEntities::DeletedTag
    end
  end

  desc "deal with error path"
  route :any, '*path' do
    error! "error path - #{routes.first.route_path.sub("*path(.:format)","")}#{params[:path]}", 404
  end
end
