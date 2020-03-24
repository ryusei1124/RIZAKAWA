class AddFixDay2ToStudents < ActiveRecord::Migration[5.1]
  def change
    add_column :students, :fix_day2, :string
    add_column :students, :fix_time2, :time
    add_column :students, :fix_day3, :string
    add_column :students, :fix_time3, :time
    remove_column :students,:examinee
    add_column :students,:examinee,:boolean, :default => false
  end
end
