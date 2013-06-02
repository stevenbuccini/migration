class User < ActiveRecord::Base
  attr_accessible :name, :oauth_expires_at, :oauth_token, :provider, :uid

  def self.from_omniauth(auth)
  	where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
	    user.provider = auth.provider
	    user.uid = auth.uid
	    user.name = auth.info.name
	    user.location = auth.info.location
	    user.image =auth.info.image
	    user.oauth_token = auth.credentials.token
	    user.oauth_expires_at = Time.at(auth.credentials.expires_at)
	    user.save!
		end
	end

  def facebook
  	 @facebook ||= Koala::Facebook::API.new(oauth_token)
  end

  def places
  	homes=Array.new
  	locs=Array.new


  	friends=facebook.get_connections("me","friends")
  	friends.each do |friend|
  		
  		person=facebook.get_object(friend["id"])
  		place1 = person["hometown"]
  		
  		
  		if (place1 !=nil) 
  			place2=person["location"]
  			if (place2 != nil)
  				homes.push(facebook.get_object(place1["id"])["location"])
  				locs.push(facebook.get_object(place2["id"])["location"])
  			end
  		end
  	end
  	self.hometowns=homes
  	self.locations=locs
  end



 	

end	
