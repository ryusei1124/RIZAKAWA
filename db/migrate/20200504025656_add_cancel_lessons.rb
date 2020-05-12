class AddCancelLessons < ActiveRecord::Migration[5.2]
  def change
     add_column :lessons, :cancel, :boolean, default: false

  end
end
