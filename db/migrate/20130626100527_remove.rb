class Remove < ActiveRecord::Migration
  def change
  	remove_column :friends, :current
  	remove_column :friends, :hometown
  	remove_column :friends, :hometown_latitude
  	remove_column :friends, :hometown_longitude
  	remove_column :friends, :current_latitude
  	remove_column :friends, :current_longitude
  end
end
