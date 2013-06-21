class ChangeColumns < ActiveRecord::Migration
  def change
  	remove_column :friends, :hometown_latitude
  	remove_column :friends, :hometown_longitude
  	remove_column :friends, :current_latitude
  	remove_column :friends, :current_longitude

  	add_column :friends, :current_longitude, :float
  	add_column :friends, :current_latitude, :float
  	add_column :friends, :hometown_longitude, :float
  	add_column :friends, :hometown_latitude, :float

  end

end
