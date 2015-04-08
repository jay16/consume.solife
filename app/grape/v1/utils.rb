#encoding: utf-8
require File.expand_path("../entities", __FILE__)
require File.expand_path("../helpers", __FILE__)
require File.expand_path("../defaults", __FILE__)
require "json"
module Consume
  module API
    module V1
      class Utils < Grape::API
        include Consume::API::V1::Defaults

        # get /api/routes
        desc "consume::api routes"
        get "/routes" do
          Consume::API::Base::routes.map{ |i| {desc: i.route_description, method: i.route_method, path: i.route_path} }.to_json 
        end

        # get /api/versions
        desc "android/ios client version"
        get "/version" do
          case params[:os].to_s
          when "android" then
            { :version     => Setting.mobile.os.android.version,
              :apk_name    => File.basename(Setting.mobile.os.android.url),
              :describtion => Setting.mobile.os.android.describtion, 
              :url         => Setting.mobile.os.android.url }
          else
              error! "#{params[:os]} should in [android]", 404
          end
        end

      end
    end
  end
end
