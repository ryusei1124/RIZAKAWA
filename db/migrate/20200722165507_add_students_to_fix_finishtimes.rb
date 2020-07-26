class AddStudentsToFixFinishtimes < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :fix_finishtime, :time
    add_column :students, :fix_finishtime2, :time
    add_column :students, :fix_finishtime3, :time
    add_column :students, :fix_finishtime4, :time
    add_column :students, :fix_finishtime5, :time
  end
end
