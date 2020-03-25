class AddCancelnumberInfoToStudents < ActiveRecord::Migration[5.1]
  def change
    add_column :students, :cancelnumber, :integer
    remove_column :reservations,:hold
    add_column :lessons,:hold,:boolean, :default => false
  end
end
