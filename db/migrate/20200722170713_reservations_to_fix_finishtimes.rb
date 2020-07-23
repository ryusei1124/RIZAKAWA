class ReservationsToFixFinishtimes < ActiveRecord::Migration[5.2]
  def change
    add_column :reservations, :fix_finishtime, :time
  end
end
