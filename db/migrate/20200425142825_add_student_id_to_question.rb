class AddStudentIdToQuestion < ActiveRecord::Migration[5.2]
  def change
    add_reference :questions, :student, foreign_key: true
  end
end
