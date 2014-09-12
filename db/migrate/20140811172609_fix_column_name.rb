class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :orders, :cart_id, :booking_id
  end

end