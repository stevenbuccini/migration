class User < ActiveRecord::Base
 
  attr_accessible :name, :oauth_expires_at, :oauth_token, :provider, :uid
  has_many :friends

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
    friends=Array.new
    home_objects=Array.new
    location_objects=Array.new
  	
  	friends_basic = facebook.batch do |batch_api|
    	batch_api.get_connections("me", "friends", {:limit => 1000}, :batch_args => {:name => "get-friends"})
    	batch_api.get_objects("{result=get-friends:$.data.*.id}")
  	end
  	friends_basic[1].each do |friend|
  		if (friend[1]["hometown"]!=nil and friend[1]["location"] !=nil)
  			homes.push(friend[1]["hometown"]["id"])
        home_objects.push(Location.new(:name => friend[1]["hometown"]["name"], :id => friend[1]["hometown"]["id"])
  			locs.push(friend[1]["location"]["id"])
        location_objects.push(Location.new(:name => friend[1]["location"]["name"], :id => friend[1]["location"]["id"]))
        friends.push(friend[1])
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

    # master=homes.zip(locs,friends)
    # master.each do |each|
    #   self.friends.new(:name => each[2]["name"],
    #     :image => each[2]["username"],
    #     :hometown => each[0],
    #     :current => each[1], 
    #     :hometown_latitude => a[each[0]]["latitude"],
    #     :hometown_longitude => a[each[0]]["longitude"],
    #     :current_longitude => b[each[1]]["longitude"],
    #     :current_latitude => b[each[1]]["latitude"]).save
    # end
 
    hometowns =homes.zip(home_objects)

    hometowns.each do |each|
      each[1].latitude = a[each[0]]["latitude"]
      each[1].longitude = a[each[0]]["longitude"]



    self.been_checked = true
    self.save
 


  end
  	
end	
