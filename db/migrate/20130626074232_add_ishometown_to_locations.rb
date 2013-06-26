class AddIshometownToLocations < ActiveRecord::Migration
  def change
  	add_column :locations, :is_hometown, :boolean
  end
end
