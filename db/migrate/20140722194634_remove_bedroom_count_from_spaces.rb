class RemoveBedroomCountFromSpaces < ActiveRecord::Migration
  def up
    remove_column :spaces, :bedroom_count
  end

  def down
    add_column :spaces, :bedroom_count, :integer
  end
end
