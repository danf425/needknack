class AddTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :token, :integer
  end
end