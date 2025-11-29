# frozen_string_literal: true

module DiscardableResource
  extend ActiveSupport::Concern

  included do
    def query
      super.with_discarded
    end

    def fields_with_discarded_at
      fields_without_discarded_at.tap do
        field :discarded_at, as: :date_time, readonly: true
      end
    end
    alias_method :fields_without_discarded_at, :fields
    alias_method :fields, :fields_with_discarded_at
  end
end
