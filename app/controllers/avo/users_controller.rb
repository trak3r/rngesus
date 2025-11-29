# frozen_string_literal: true

# This controller has been generated to enable Rails' resource routes.
# More information on https://docs.avohq.io/3.0/controllers.html
module Avo
  class UsersController < Avo::ResourcesController
    include Avo::Concerns::SoftDeletableResource

    private

    def resource_index_path
      avo.resources_users_path
    end
  end
end
