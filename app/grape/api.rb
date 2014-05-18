require "entities"
require "helpers"

class Api < Grape::API
  prefix "api"
  format :json

  helpers APIHelpers

  resource :users do

    #validate user with token
    #Example
    # /api/users/validate.json
    get :validate do
      authenticate!
      present current_user, with: APIEntities::User
    end
  end
 
  resource :records do

    # Post a new record
    # require authentication
    # Example
    # post /api/records.json
    # Params:
    # record[:value]  consume value
    # record[:remark] consume remark
    # record[:ymdhms] consume timestamp
    # record[:klass]  consume klass
    post do
      authenticate!
      record = current_user.records.create(params[:reocrd])
      present record, with: APIEntities::Record
    end

    # Get record list 
    # Example
    # get  /api/records/index.json
    # params:
    # params[:page]
    # params[:per_page]: default is 30
    # params[:type]: default(or empty) excellent no_reply popular last
    # Example
    #   /api/topics/index.json?page=1&per_page=15
    get do
      authenticate!
      records = current_user.records
      present records, with: APIEntities::Record
    end

    # Update a record
    # Example
    # put /api/recores/index.json
    # params:
    # params[:id]
    # params[:recored]
    put do
      authenticate!
      record = current_user.records.find_by(:id, params[:id])
      record.update_attributes(params[:record])
      present records, with: APIEntities::Record
    end
  end

  resource :tags do

    # Post a sms with find_or_create
    # Exaple
    # /api/tags.json
    post do
      authenticate!
      tag = current_user.tags.create(params[:tag])

      present tag, with: APIEntities::Tag
    end
  end

end
