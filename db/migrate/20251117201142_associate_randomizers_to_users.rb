# frozen_string_literal: true

class AssociateRandomizersToUsers < ActiveRecord::Migration[8.1]
  def change
    Randomizer.destroy_all if Rails.env.development?

    change_table :randomizers do |t|
      t.references :user, null: false, foreign_key: true
    end
  end
end
