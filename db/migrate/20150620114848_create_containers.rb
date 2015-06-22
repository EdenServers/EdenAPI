class CreateContainers < ActiveRecord::Migration
  def change
    create_table :containers do |t|
      t.string :name
      t.text :description
      t.text :command

      t.timestamps null: false
    end
  end
end
