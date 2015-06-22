class AddReadyToImages < ActiveRecord::Migration
  def change
    add_column :images, :ready, :boolean, default: false
  end
end
