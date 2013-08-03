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
    
  	# all_friends_basic_info.last = "100006342546506"=>{"id"=>"100006342546506", "name"=>"Summerset Thompson", 
    # "first_name"=>"Summerset", "last_name"=>"Thompson", "link"=>"https://www.facebook.com/summerset.thompson.1",
    # "username"=>"summerset.thompson.1", "hometown"=>{"id"=>"110714572282163", "name"=>"San Diego, California"}, 
    # "gender"=>"female", "locale"=>"en_US", "updated_time"=>"2013-07-14T03:11:49+0000"}}]

  	all_friends_basic_info = get_friends_basic_information()

    homes,homenames,locs,locationnames,friends=setup_variables(all_friends_basic_info)

    a,b = step2(homes,locs)

    make_hometowns_and_friend_subarrays(a,homes,homenames,friends)

    make_locations_and_friend_subarrays(b,locs,locationnames,friends)

    self.been_checked = true
    self.save
 


  end

  

  def get_friends_basic_information

    all_friends_basic_info = facebook.batch do |batch_api|
      batch_api.get_connections("me", "friends", {:limit => 1000}, :batch_args => {:name => "get-friends"})
      batch_api.get_objects("{result=get-friends:$.data.*.id}")
    end
  end

  def step2(homes, locs)

    homes_almost,locs_almost=facebook.batch do |batch_api|
      batch_api.get_objects(homes)
      batch_api.get_objects(locs)
    end


    # a.first = ["110714572282163", {"street"=>"", "zip"=>"", "latitude"=>32.715, "longitude"=>-117.1625}]  
    a=Hash.new
    b=Hash.new

    homes_almost.each_key do |key|
      a[key]=homes_almost[key]["location"]
    end
    locs_almost.each_key do |key|
      b[key]=locs_almost[key]["location"]
    end


    return a, b
  end

  def setup_variables(friends_basic)
        #homes = ["105545799477946", "110714572282163", "106007332772985"]
    homes=Array.new 

    #locs = ["105545799477946", "110714572282163", "106007332772985"]
    locs=Array.new

    #{"id"=>"203872", "name"=>"Rob Landis", "first_name"=>"Rob", "last_name"=>"Landis", 
    # "link"=>"https://www.facebook.com/rob.landis.90", 
    # "username"=>"rob.landis.90", 
    # "hometown"=>{"id"=>"110714572282163", "name"=>"San Diego, California"},
    # "location"=>{"id"=>"110714572282163", "name"=>"San Diego, California"}, 
    # "gender"=>"male", "locale"=>"en_US", "updated_time"=>"2013-06-23T19:20:10+0000"}
    friends=Array.new

    #homenames= [La Jolla, California", "Carlsbad, California", "San Diego, California"]
    homenames=Array.new

    #homenames= [La Jolla, California", "Carlsbad, California", "San Diego, California"]
    locationnames=Array.new

    friends_basic[1].each do |friend|
      if (friend[1]["hometown"]!=nil and friend[1]["location"] !=nil)
        homes.push(friend[1]["hometown"]["id"])
        homenames.push(friend[1]["hometown"]["name"])
        locs.push(friend[1]["location"]["id"])
        locationnames.push(friend[1]["location"]["name"])
        friends.push(friend[1] )
      end
    end

    return homes,homenames,locs,locationnames,friends
  end

  def make_hometowns_and_friend_subarrays(a,homes,homenames,friends)


    hometown_objects = Hash.new
    
    master_hometowns=homes.zip(homenames,friends)
    master_hometowns.each do |each|
      if a[each[0]] != nil
      if hometown_objects[each[0]] == nil
        self.locations.new(:name => each[1], :fb_id => each[0], 
          :latitude => a[each[0]]["latitude"], 
          :longitude => a[each[0]]["longitude"],
          :is_hometown => true).save
          hometown_objects[each[0]]=each[0]
       end
      self.locations.where(fb_id: each[0]).first.friends.new(:name => each[2]["name"],
        :fb_userid => each[2]["id"], :hometown => each[2]["hometown"]["id"], :current_location => each[2]["location"]["id"]).save
    end
  end
 end

 def make_locations_and_friend_subarrays(b,locs,locationnames,friends)

    location_objects=Hash.new

    master_current_locations=locs.zip(locationnames,friends)
    master_current_locations.each do |each|
      if b[each[0]] != nil
        if location_objects[each[0]] == nil
          self.locations.new(:name => each[1], :fb_id => each[0], 
            :latitude => b[each[0]]["latitude"], 
            :longitude => b[each[0]]["longitude"],
            :is_hometown => false).save
            location_objects[each[0]]=each[0]
        end
         self.locations.where(fb_id: each[0], is_hometown: false).first.friends.new(:name => each[2]["name"],
          :fb_userid => each[2]["id"], :hometown => each[2]["location"]["id"], :current_location => each[2]["hometown"]["id"]).save
      end
    end
  end
  	
end	
