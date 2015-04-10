#encoding: utf-8
require File.expand_path("../common", __FILE__)
require File.expand_path("../v1/base", __FILE__)
module Consume
  module API
    class Base < Grape::API
      # common api without version
      mount Consume::API::Common

      # api versions list
      mount Consume::API::V1::Base

      # cannot matched routes
      desc "deal with error path"
      route :any, '*path' do
        error! "error path - #{routes.first.route_path.sub("*path(.:format)","")}#{params[:path]}", 404
      end
    end
  end
end
