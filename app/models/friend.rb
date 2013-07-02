class Friend < ActiveRecord::Base
	belongs_to :location
  attr_accessible :current_location, :hometown, :fb_userid, :name
end
