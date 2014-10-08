class AddTokenToSpaces < ActiveRecord::Migration
  def change
    add_column :spaces, :token, :integer
  end
end