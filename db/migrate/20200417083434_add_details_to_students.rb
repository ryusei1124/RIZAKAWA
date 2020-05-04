class AddDetailsToStudents < ActiveRecord::Migration[5.2]
  def change
    t.boolean "cancel", default: false
  end
end
