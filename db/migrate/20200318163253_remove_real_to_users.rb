class RemoveRealToUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :real, :string
    remove_column :users, :sex, :string
    remove_column :users, :school, :string
    remove_column :users, :attendance_time, :string
    remove_column :users, :leave_time, :string
    remove_column :users, :fix_time, :string
    remove_column :users, :school_year, :string
    remove_column :users, :fix_day, :string
    remove_column :users, :birthday, :string
  end
end
