class AddAvatarToSpaces < ActiveRecord::Migration
  def self.up
    add_attachment :spaces, :avatar
  end

  def self.down
    remove_attachment :spaces, :avatar
  end
end