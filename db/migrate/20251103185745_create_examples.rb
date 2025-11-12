# frozen_string_literal: true

class CreateExamples < ActiveRecord::Migration[8.1]
  def change
    create_table :examples do |t|
      t.string :name
      t.integer :value

      t.timestamps
    end
  end
end
