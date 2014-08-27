class AddStartTimeToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :start_time, :integer
    add_column :bookings, :end_time, :integer
  end
end
