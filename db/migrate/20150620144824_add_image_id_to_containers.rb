class AddImageIdToContainers < ActiveRecord::Migration
  def change
    add_column :containers, :image_id, :integer
  end
end
