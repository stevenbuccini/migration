class Updateuser < ActiveRecord::Migration
  def change

  	remove_column :friends, :image

  	add_column :friends, :fb_userid, :string
  end

end
