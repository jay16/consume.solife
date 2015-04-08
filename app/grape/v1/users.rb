#encoding: utf-8
require File.expand_path("../entities", __FILE__)
require File.expand_path("../helpers", __FILE__)
require File.expand_path("../defaults", __FILE__)
require "json"
module Consume
  module API
    module V1
      class Users < Grape::API
        include Consume::API::V1::Defaults

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

      end
    end
  end
end
