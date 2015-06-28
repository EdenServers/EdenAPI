class CreatePorts < ActiveRecord::Migration
  def change
    create_table :ports do |t|
      t.integer :host_port
      t.integer :container_port

      t.timestamps null: false
    end
  end
end
