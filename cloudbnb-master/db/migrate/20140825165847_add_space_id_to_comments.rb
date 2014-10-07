class AddSpaceIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :space_id, :integer
    add_index :comments, :space_id
  end
end
