#encoding: utf-8
module Consume
  module API
    module V1
      module Defaults
        # if you're using Grape outside of Rails, you'll have to use Module#included hook
        extend ActiveSupport::Concern
        
        # common Grape settings
        included do
          # version "v1"
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
        end
      end
    end
  end
end
