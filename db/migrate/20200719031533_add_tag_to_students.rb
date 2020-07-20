class AddTagToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :fix_day5, :string
    add_column :students, :fix_time5, :time
  end
end
