class Update1 < ActiveRecord::Migration
  def up
  	remove_column :friends, :user_id
  	remove_column :friends, :location_id
  	add_column :friends, :hometown, :array
  	add_column :friends, :current_location, :array
  end

  def down
  end
end
