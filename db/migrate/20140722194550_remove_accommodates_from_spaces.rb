class RemoveAccommodatesFromSpaces < ActiveRecord::Migration
  def up
    remove_column :spaces, :accommodates
  end

  def down
    add_column :spaces, :accommodates, :integer
  end
end
