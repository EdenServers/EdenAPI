class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :image_id
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end
