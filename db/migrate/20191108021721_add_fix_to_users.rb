class AddFixToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :fix_day, :date
    add_column :users, :fix_time, :datetime
  end
end
