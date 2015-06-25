class FixImageId < ActiveRecord::Migration
  def change
    rename_column :images, :image_id, :docker_image_id
  end
end
