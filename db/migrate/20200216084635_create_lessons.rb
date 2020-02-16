class CreateLessons < ActiveRecord::Migration[5.1]
  def change
    create_table :lessons do |t|
      t.date :meeting_on, :null => false
      t.time :started_at, :null => false
      t.time :finished_at, :null => false
      t.text :note
      t.string :target
      t.integer :seats_zoom
      t.integer :seats_real
      t.boolean :off_day, :null => false, :default => false
      t.boolean :rescheduled, :null => false, :default => false
      t.boolean :regular, :null => false, :default => true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
