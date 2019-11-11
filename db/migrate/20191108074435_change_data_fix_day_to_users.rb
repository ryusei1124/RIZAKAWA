class ChangeDataFixDayToUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :fix_day, :string
  end
end
