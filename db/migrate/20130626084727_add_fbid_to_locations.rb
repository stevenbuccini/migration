class AddFbidToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :fb_id, :string
  end
end
