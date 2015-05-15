#encoding: utf-8
require File.expand_path("../entities", __FILE__)
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

          # get /api/users/user_report.json
          desc "get user report"
          get "/user_report" do
            authenticate!
            user_report = current_user.generate_user_report
            present user_report, with: APIEntities::UserReport
          end

          # get /api/users/group_member_report.json
          desc "get group members report"
          get "/group_member_report" do
            authenticate!
            group_report = current_user.group_member_report(params[:num_day_ago] || 1, params[:report_type] || "text")
            { report: group_report }
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
