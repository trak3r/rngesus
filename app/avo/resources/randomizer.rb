# frozen_string_literal: true

class Avo::Resources::Randomizer < Avo::BaseResource
  self.includes = []

  def fields
    field :id, as: :id
    field :name, as: :text
    field :slug, as: :text, readonly: true
    field :cached_votes_total, as: :number, readonly: true, name: "Likes"
    field :user, as: :belongs_to
    field :tags, as: :has_many, through: :randomizer_tags
    field :rolls, as: :has_many
    field :created_at, as: :date_time, readonly: true
    field :updated_at, as: :date_time, readonly: true
  end
end
