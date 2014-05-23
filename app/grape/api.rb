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

  # logger params for all api
  before do
    logger.info "Params:\n#{params.to_json}"
  end

  desc "consume::api routes"
  get "/routes" do
    Consume::API::routes
      .map{ |i| { "desc" => i.route_description, "method" => i.route_method, "path" => i.route_path } }
      .to_json
  end

  # validation user for below api
  before_validation do
    authenticate!
  end


  resource :users do
    # get /api/users.json?token=abc
    desc "get user info with token."
    get do
      present current_user, with: APIEntities::User
    end

    # put /api/users.json?name=new_name
    desc "update user info."
    post do
      current_user.update(params[:user])
      present current_user, with: APIEntities::User
    end
  end
 
  resource :records do
    # post /api/records.json
    desc "create a new record."
    post do
      record_params = params[:record].is_a?(String) ? eval(params[:record]) : params[:record]
      record = current_user.records.create(record_params)
      present record, with: APIEntities::Record
    end

    # get /api/records.json
    desc "get record list."
    get do
      records = current_user.records 
      present records, with: APIEntities::Record
    end

    # get /api/records/1.json
    desc "get a record."
    get "/:id" do
      record = current_user.records.find_by(:id, params[:id])
      present record, with: APIEntities::Record
    end

    # put /api/recores/1.json
    desc "update a record."
    post "/:id" do
      record = current_user.records.find_by(:id, params[:id])
      record.update(params[:record])
      present records, with: APIEntities::Record
    end
  end

  resource :tags do
    # get /api/tags.json
    desc "get tag list."
    get do
      tags = current_user.tags
      present tags, with: APIEntities::Tag
    end

    # get /api/tags.json
    desc "get a tag."
    get "/:id" do
      tag = current_user.tags.find_by(:id, params[:id])
      present tag, with: APIEntities::Tag
    end

    # post /api/tags.json
    desc "create a new tag."
    post do
      tag = current_user.tags.find_or_create(params[:tag])
      present tag, with: APIEntities::Tag
    end

    # post /api/tags.json
    desc "update a tag."
    post "/:id" do
      tag = current_user.tags.find_by(:id, params[:id])
      tag.update(params[:tag])
      present tag, with: APIEntities::Tag
    end
  end

  desc "deal with error path"
  route :any, '*path' do
    error! "error path - #{routes.first.route_path.sub("*path(.:format)","")}#{params[:path]}", 404
  end
end
