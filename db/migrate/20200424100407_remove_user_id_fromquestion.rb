class RemoveUserIdFromquestion < ActiveRecord::Migration[5.2]
  def change
    remove_column :questions, :user_id
  end
end
