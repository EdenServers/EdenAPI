class AddTypeToPorts < ActiveRecord::Migration
  def change
    add_column :ports, :type, :string, default: 'tcp'
  end
end
