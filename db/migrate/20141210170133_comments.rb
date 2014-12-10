class Comments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id, null: false
      t.string :meetup_id, null: false
      t.string :comment, null: false

      t.timestamp
    end
  end
end
