# frozen_string_literal: true

module Avo
  module Resources
    class User < Avo::BaseResource
      include DiscardableResource
      # self.includes = []
      # self.attachments = []
      # self.search = {
      #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
      # }

      def fields
        field :id, as: :id
        field :provider, as: :text
        field :uid, as: :text
        field :email, as: :text
        field :name, as: :text
        field :nickname, as: :text
        field :randomizers, as: :has_many
        field :created_at, as: :date_time, readonly: true
        field :updated_at, as: :date_time, readonly: true
      end
    end
  end
end
