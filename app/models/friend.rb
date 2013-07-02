class Friend < ActiveRecord::Base
	belongs_to :location
  attr_accessible :current, :hometown, :fb_userid, :name, :location_id
end
