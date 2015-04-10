#encoding: utf-8
require File.expand_path("../users", __FILE__)
require File.expand_path("../records", __FILE__)
require File.expand_path("../tags", __FILE__)
module Consume
  module API
    module V1
      class Base < Grape::API
        mount Consume::API::V1::Users
        mount Consume::API::V1::Records
        mount Consume::API::V1::Tags
      end
    end
  end
end
