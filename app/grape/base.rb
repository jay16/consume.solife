#encoding: utf-8
require File.expand_path("../v1/base", __FILE__)
module Consume
  module API
    class Base < Grape::API
      mount Consume::API::V1::Base

       
      desc "deal with error path"
      route :any, '*path' do
        error! "error path - #{routes.first.route_path.sub("*path(.:format)","")}#{params[:path]}", 404
      end
    end
  end
end
