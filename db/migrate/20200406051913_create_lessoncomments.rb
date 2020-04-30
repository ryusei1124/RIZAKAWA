class CreateLessoncomments < ActiveRecord::Migration[5.2]
  def change
    create_table :lessoncomments do |t|
      t.integer :lesson_id, null: false
      t.integer :user_id, null: false
      t.integer :reservation_id
      t.integer :student_id
      t.string :content, null: false
      t.integer :noted, :default => 0

      t.timestamps
    end
  end
end
