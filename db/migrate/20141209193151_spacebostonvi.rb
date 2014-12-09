class Spacebostonvi < ActiveRecord::Migration
  def change
    add_column :attendees, :user_id, :integer
    add_column :attendees, :meetup_id, :integer
  end
end
