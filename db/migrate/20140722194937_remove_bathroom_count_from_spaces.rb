class RemoveBathroomCountFromSpaces < ActiveRecord::Migration
  def up
    remove_column :spaces, :bathroom_count
  end

  def down
    add_column :spaces, :bathroom_count, :integer
  end
end
