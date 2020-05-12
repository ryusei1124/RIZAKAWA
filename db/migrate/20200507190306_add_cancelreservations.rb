class AddCancelreservations < ActiveRecord::Migration[5.2]
  def change
    add_column :reservations, :cancel, :boolean, default: false
  end
end
