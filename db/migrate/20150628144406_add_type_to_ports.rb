class AddTypeToPorts < ActiveRecord::Migration
  def change
    add_column :ports, :port_type, :string
  end
end
