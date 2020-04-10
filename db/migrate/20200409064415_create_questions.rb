class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.integer :user_id, null: false
      t.string :question_title, null: false
      t.text :question_content, null: false
      t.integer :student_id
      t.integer :destination, null: false

      t.timestamps
    end
  end
end
