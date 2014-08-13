class RemoveGuestCountFromBookings < ActiveRecord::Migration
  def up
    remove_column :bookings, :guest_count
  end

  def down
    add_column :bookings, :guest_count, :integer
  end
end
