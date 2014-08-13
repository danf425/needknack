class RemoveAmenitiesFromSpaces < ActiveRecord::Migration
  def up
    remove_column :spaces, :amenities
  end

  def down
    add_column :spaces, :amenities, :integer
  end
end
