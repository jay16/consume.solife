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

  # validation user before all api
  before_validation do
    authenticate!
  end

  resource :users do
    # validate user with token
    # Example:
    # get /api/users.json?token=abc
    get do
      present current_user, with: APIEntities::User
    end

    # update user info
    # Example:
    # put /api/users.json?name=new_name
    put do
      current_user.update(params[:user])
      present current_user, with: APIEntities::User
    end
  end
 
  resource :records do
    # Post a new record
    # Example
    # post /api/records.json
    # Params:
    # record[:record][{}]
    post do
      record_params = params[:record].is_a?(String) ? eval(params[:record]) : params[:record]
      record = current_user.records.create(record_params)
      present record, with: APIEntities::Record
    end

    # Get record list 
    # Example
    # get  /api/records/index.json
    get do
      records = current_user.records 
      present records, with: APIEntities::Record
    end

    # Update a record
    # Example
    # put /api/recores.json
    # params:
    # params[:id]
    # params[:recored][{}]
    put do
      record = current_user.records.find_by(:id, params[:id])
      record.update_attributes(params[:record])
      present records, with: APIEntities::Record
    end
  end

  resource :tags do

    # get tags list 
    # Example
    # get /api/tags.json
    get do
      tags = current_user.tags
      present tags, with: APIEntities::Tag
    end
    # Post a tag
    # Example
    # post /api/tags.json
    post do
      tag = current_user.tags.find_or_create(params[:tag])
      present tag, with: APIEntities::Tag
    end
  end

end
