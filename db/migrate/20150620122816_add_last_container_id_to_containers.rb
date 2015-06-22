class AddLastContainerIdToContainers < ActiveRecord::Migration
  def change
    add_column :containers, :docker_container_id, :string
  end
end
