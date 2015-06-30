class AddContainerIdToPorts < ActiveRecord::Migration
  def change
    add_column :ports, :container_id, :integer, default: 0
  end
end
