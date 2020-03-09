class AddguardianTostudents < ActiveRecord::Migration[5.1]
  def change
    add_column :students, :studentkana, :string
  end
end
