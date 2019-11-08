class AddUserInformationToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :student, :string
    add_column :users, :real, :boolean, default: false
    add_column :users, :zoom, :boolean, default: false
    add_column :users, :sex, :string
    add_column :users, :school, :string
    add_column :users, :school_year, :integer
    add_column :users, :admin, :boolean, default: false
    add_column :users, :attendance_time, :datetime
    add_column :users, :leave_time, :datetime
  end
end
