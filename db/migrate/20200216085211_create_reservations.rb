class CreateReservations < ActiveRecord::Migration[5.1]
  def change
    create_table :reservations do |t|
      t.boolean :attendance, :null => false, :default => true
      t.boolean :zoom, :null => false, :default => false
      t.string :note
      t.references :user, foreign_key: true
      t.references :lesson, foreign_key: true
      t.timestamps
    end
  end
end
