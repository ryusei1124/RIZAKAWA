class AddguardianToUsers < ActiveRecord::Migration[5.1]
  def change
     add_column :users, :guardiankana, :string
  end
end
