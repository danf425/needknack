class FixSpaceEndDate < ActiveRecord::Migration
  def change
change_column :bookings, :end_date, :date, :null => true
  end

end