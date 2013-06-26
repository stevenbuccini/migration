class Location < ActiveRecord::Base
  attr_accessible :id, :latitude, :longitude, :name
end
