class AddWaitingToReservations < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :waiting, :boolean, :default => false
    add_column :reservations, :attendance_time, :time
    add_column :reservations, :leave_time, :time
    add_column :reservations, :absence, :boolean, :default => false
    add_column :reservations, :transfer, :boolean, :default => false
    add_column :reservations, :fix_time, :time
  end
end
