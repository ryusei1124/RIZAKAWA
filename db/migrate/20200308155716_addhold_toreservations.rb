class AddholdToreservations < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :hold, :boolean, :default => true
  end
end
