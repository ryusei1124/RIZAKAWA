class CreateNotices < ActiveRecord::Migration[5.1]
  def change
    create_table :notices do |t|
      t.string :notice_title
      t.text :notice_content
      t.boolean :all_destinate
      t.boolean :part_of_destinate
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
