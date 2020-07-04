class AddFixDay4ToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :fix_day4, :string
    add_column :students, :fix_time4, :time
  end
end
