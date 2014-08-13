class RemoveRoomTypeFromSpaces < ActiveRecord::Migration
  def up
    remove_column :spaces, :room_type
  end

  def down
    add_column :spaces, :room_type, :integer
  end
end
