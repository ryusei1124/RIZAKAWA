class AddExamineeToLessons < ActiveRecord::Migration[5.1]
  def change
    add_column :lessons, :examinee, :boolean, :default => false
  end
end
