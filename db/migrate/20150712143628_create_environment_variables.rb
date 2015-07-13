class CreateEnvironmentVariables < ActiveRecord::Migration
  def change
    create_table :environment_variables do |t|
      t.string :key
      t.string :value

      t.timestamps null: false
    end
  end
end
