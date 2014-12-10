class Meetup < ActiveRecord::Base
 has_many :attendees
 has_many :users, :through => :attendees
 has_many :comments

end
