# frozen_string_literal: true

module Avo
  class RandomizersController < Avo::ResourcesController
    include Avo::Concerns::SoftDeletableResource

    private

    def resource_index_path
      avo.resources_randomizers_path
    end
  end
end
