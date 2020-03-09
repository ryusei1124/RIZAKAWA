class AddReservationTostudentId < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :student_id, :integer
  end
end
