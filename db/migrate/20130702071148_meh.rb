class Meh < ActiveRecord::Migration
  def up
  	add_column :friends, :location_id, :integer
  end

  def down
  end
end
