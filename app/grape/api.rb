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

    # validate the phone with find_or_create
    # Example
    # /api/records.json
    # Params:
    # token
    # photo:
    #  serial
    #  manufacturer
    #  model
    post do
      authenticate!
      record = current_user.records.create(params[:reocrd])
      present record, with: APIEntities::Record
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
