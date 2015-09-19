class AddCustomToPorts < ActiveRecord::Migration
  def change
    add_column :ports, :custom, :boolean, default: false
  end
end
