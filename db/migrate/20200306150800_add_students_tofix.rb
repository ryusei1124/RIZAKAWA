class AddStudentsTofix < ActiveRecord::Migration[5.1]
  def change
     add_column :students, :fix_day, :string

    add_column :students, :fix_time, :time

  end
end
