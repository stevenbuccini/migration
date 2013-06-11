class User < ActiveRecord::Base
  serialize :hometowns, Array
  serialize :locations, Array
  serialize :hometowns_info, Hash
  serialize :locations_info, Hash
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
      user.been_checked=false
	    user.save!
		end
	end

  def facebook
  	 @facebook ||= Koala::Facebook::API.new(oauth_token)
  end


  def places
  	homes=Array.new
  	locs=Array.new
  	
  	friends_basic = facebook.batch do |batch_api|
    	batch_api.get_connections("me", "friends", {:limit => 1000}, :batch_args => {:name => "get-friends"})
    	batch_api.get_objects("{result=get-friends:$.data.*.id}")
  	end
  	friends_basic[1].each do |friend|
  		if (friend[1]["hometown"]!=nil and friend[1]["location"] !=nil)
  			homes.push(friend[1]["hometown"]["id"])
  			locs.push(friend[1]["location"]["id"])
  		end
  	end
  	
  	homes_almost,locs_almost=facebook.batch do |batch_api|
  		batch_api.get_objects(homes)
  		batch_api.get_objects(locs)
  	end

  	a=Hash.new
  	b=Hash.new

  	homes_almost.each_key do |key|
  		a[key]=homes_almost[key]["location"]
  	end
  	locs_almost.each_key do |key|
  		b[key]=locs_almost[key]["location"]
  	end


  	self.hometowns=homes
  	self.locations=locs
  	self.hometowns_info=a
  	self.locations_info=b

    self.been_checked = true
    self.save
 


  end
  	
end	
