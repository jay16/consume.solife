#encoding: utf-8
require File.expand_path("../../defaults", __FILE__)

module Consume
  module API
    module V1
      module Defaults
        # if you're using Grape outside of Rails, you'll have to use Module#included hook
        extend ActiveSupport::Concern
        include Consume::API::Defaults

        # common Grape settings
        included do
           version "v1"
        end

      end
    end
  end
end
