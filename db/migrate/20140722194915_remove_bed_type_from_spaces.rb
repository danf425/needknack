class RemoveBedTypeFromSpaces < ActiveRecord::Migration
  def up
    remove_column :spaces, :bed_type
  end

  def down
    add_column :spaces, :bed_type, :integer
  end
end
