class AddUserRefToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_reference :answers, :user, foreign_key: true
    add_reference :answers, :student, foreign_key: true
    add_reference :answers, :question, foreign_key: true
  end
end
