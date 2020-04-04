class CreateLessoncomments < ActiveRecord::Migration[5.2]
  def change
    create_table :lessoncomments do |t|
      t.integer :lesson＿id
      t.integer :user_id
      t.integer :student_id
      t.string :content
      t.integer :noted, :default => 0

      t.timestamps
    end
  end
end
