class Unique < ActiveRecord::Migration
  def change
    add_index(:attendees, [:user_id, :meetup_id], unique: true)
    add_index(:meetups, :name, unique: true)
  end
end
