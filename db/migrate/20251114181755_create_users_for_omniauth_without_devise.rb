# frozen_string_literal: true

class CreateUsersForOmniauthWithoutDevise < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :email
      t.string :name
      t.timestamps
    end

    add_index :users, %i[provider uid], unique: true
  end
end
