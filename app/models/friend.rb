class Friend < ActiveRecord::Base
	belongs_to :user
  attr_accessible :current, :current_latitude, :current_longitude, :hometown, :hometown_latitude, :hometown_longitude, :image, :name
end
