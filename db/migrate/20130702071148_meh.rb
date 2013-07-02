class Meh < ActiveRecord::Migration
  def up
  	add_column :friends, :location_id, :int
  end

  def down
  end
end
