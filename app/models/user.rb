# frozen_string_literal: true

class User < ApplicationRecord
  validates :provider, :uid, presence: true
end
