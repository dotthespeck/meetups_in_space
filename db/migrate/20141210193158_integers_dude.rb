class IntegersDude < ActiveRecord::Migration
  def up
    remove_column :comments, :meetup_id
  end

  def down
    add_column :comments, :meetup_id, :string
  end
end
