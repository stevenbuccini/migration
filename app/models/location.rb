class Location < ActiveRecord::Base
  attr_accessible :id, :latitude, :longitude, :name, :is_hometown, :friend_id, :fb_id

  has_many :friends
end
