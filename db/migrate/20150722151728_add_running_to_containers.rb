class AddRunningToContainers < ActiveRecord::Migration
  def change
    add_column :containers, :running, :boolean, default: false
  end
end
