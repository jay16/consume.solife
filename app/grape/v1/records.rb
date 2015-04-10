#encoding: utf-8
require File.expand_path("../entities", __FILE__)
require File.expand_path("../defaults", __FILE__)
require "json"
module Consume
  module API
    module V1
      class Records < Grape::API
        include Consume::API::V1::Defaults

        # core object [records]
        resource :records do
          # get /api/records.json
          desc "get record list."
          get do
            authenticate!
            unless params[:updated_at].nil?
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

      end
    end
  end
end
