class Meh < ActiveRecord::Migration
  def up
  	remove_column :friends, :user_id
	remove_column :friends, :location_id
  	add_column :friends, :location_id, :integer
  end

  def down
  end
end
