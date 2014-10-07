class AddTokenToSpaces < ActiveRecord::Migration
  def change
    add_column :spaces, :token, :string
  end
end