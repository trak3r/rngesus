class AddNameToRandomizers < ActiveRecord::Migration[8.1]
  def change
    add_column :randomizers, :name, :string
  end
end
