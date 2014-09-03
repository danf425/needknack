class AddSenderIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :sender_id, :integer
    add_index :comments, :sender_id
  end
end
