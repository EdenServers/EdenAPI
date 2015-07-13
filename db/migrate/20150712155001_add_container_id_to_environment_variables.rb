class AddContainerIdToEnvironmentVariables < ActiveRecord::Migration
  def change
    add_column :environment_variables, :container_id, :integer
  end
end
