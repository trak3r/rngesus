# frozen_string_literal: true

module Avo
  module Resources
    class Randomizer < Avo::BaseResource
      self.includes = []

      # Override to use database ID instead of slug in Avo URLs
      def record_path
        avo.resources_randomizer_path(record.id)
      end

      def fields
        field :id, as: :id
        field :name, as: :text
        field :slug, as: :text, readonly: true
        field :cached_votes_total, as: :number, readonly: true, name: 'Likes'
        field :user, as: :belongs_to
        field :tags, as: :has_many, through: :randomizer_tags
        field :rolls, as: :has_many
        field :discarded_at, as: :date_time, readonly: true
        field :created_at, as: :date_time, readonly: true
        field :updated_at, as: :date_time, readonly: true
      end

      # Show all records including discarded ones in Avo admin
      def query
        super.with_discarded
      end
    end
  end
end
