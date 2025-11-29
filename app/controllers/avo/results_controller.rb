# frozen_string_literal: true

module Avo
  class ResultsController < Avo::ResourcesController
    include Avo::Concerns::SoftDeletableResource

    private

    def resource_index_path
      avo.resources_results_path
    end
  end
end
