class CreateStudents < ActiveRecord::Migration[5.1]
  def change
    create_table :students do |t|
      t.string :student_name
      t.boolean :real, :default => false
      t.boolean :zoom, :default => false
      t.string :school
      t.integer :school_year
      t.time :attendance_time
      t.datetime :leave_time
      t.datetime :birthday
      t.integer :user_id

      t.timestamps
    end
  end
end
