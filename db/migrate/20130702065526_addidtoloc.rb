class Addidtoloc < ActiveRecord::Migration
  def up
  	add_column :locations, :location_id, :integer
  end

  def down
  end
end
