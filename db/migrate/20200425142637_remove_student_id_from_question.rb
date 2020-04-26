class RemoveStudentIdFromQuestion < ActiveRecord::Migration[5.2]
  def change
    remove_column :questions, :student_id, :integer
  end
end
