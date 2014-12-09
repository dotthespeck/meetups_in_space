class SuckMyInteger < ActiveRecord::Migration
  def up
    remove_column :attendees, :user_id
    remove_column :attendees, :meetup_id
  end

    def down
      add_column :attendees, :user_id, :string
      add_column :attendees, :meetup_id, :string
    end
end
