class CreateRandomizers < ActiveRecord::Migration[8.1]
  def change
    create_table :randomizers do |t|
      t.timestamps
    end
  end
end
