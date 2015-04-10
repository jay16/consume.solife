#encoding: utf-8
require File.expand_path("../entities", __FILE__)
require File.expand_path("../defaults", __FILE__)
require "json"
module Consume
  module API
    module V1
      class Tags < Grape::API
        include Consume::API::V1::Defaults

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
       
      end
    end
  end
end
