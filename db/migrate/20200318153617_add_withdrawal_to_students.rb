class AddWithdrawalToStudents < ActiveRecord::Migration[5.1]
  def up
    add_column :students, :withdrawal, :date
    add_column :students, :examinee, :boolean
  end
  def down
    remove_column :students,:leave_time
  end
end
