class User < ActiveRecord::Base
 
  attr_accessible :name, :oauth_expires_at, :oauth_token, :provider, :uid
  
  has_many :locations

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
    friends=Array.new

    homenames=Array.new
    locationnames=Array.new

    
  	
  	friends_basic = facebook.batch do |batch_api|
    	batch_api.get_connections("me", "friends", {:limit => 1000}, :batch_args => {:name => "get-friends"})
    	batch_api.get_objects("{result=get-friends:$.data.*.id}")
  	end
  	friends_basic[1].each do |friend|
  		if (friend[1]["hometown"]!=nil and friend[1]["location"] !=nil)
  			homes.push(friend[1]["hometown"]["id"])
        homenames.push(friend[1]["hometown"]["name"])
  			locs.push(friend[1]["location"]["id"])
        locationnames.push(friend[1]["location"]["name"])
        friends.push(friend[1] )
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

    hometown_objects = Hash.new
    location_objects=Hash.new

    master_hometowns=homes.zip(homenames,friends)
    master_hometowns.each do |each|
      if hometown_objects[each[0]] == nil
        self.locations.new(:name => each[1], :fb_id => each[0], 
          :latitude => a[each[0]]["latitude"], 
          :longitude => a[each[0]]["longitude"],
          :is_hometown => true).save
          hometown_objects[each[0]]=each[0]
       end
      Location.where(fb_id: each[0]).first.friends.new(:name => each[2]["name"],
      :fb_userid => each[2]["id"], :hometown => each[2]["hometown"]["id"]).save
    end

    master_current_locations=locs.zip(locationnames,friends)
    master_current_locations.each do |each|
      if location_objects[each[0]] == nil
        self.locations.new(:name => each[1], :fb_id => each[0], 
          :latitude => b[each[0]]["latitude"], 
          :longitude => b[each[0]]["longitude"],
          :is_hometown => false).save
          location_objects[each[0]]=each[0]
       end
       current_friend_id=each[2]["id"]
       Location.where(fb_id:  each[0]).first.friends.push(Friend.where(fb_userid: current_friend_id)).save
       Friend.where(fb_userid:  current_friend_id).current_location=each[2]["location"]["id"]

    end


    self.been_checked = true
    self.save
 


  end
  	
end	
