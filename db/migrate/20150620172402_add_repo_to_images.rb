class AddRepoToImages < ActiveRecord::Migration
  def change
    add_column :images, :repo, :string
  end
end
