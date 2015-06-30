class AddPortsToImages < ActiveRecord::Migration
  def change
    add_column :images, :ports, :string
  end
end
