class Locationsinfro < ActiveRecord::Migration
  def change
    add_column :users, :hometowns_info, :array
    add_column :users, :locations_info, :array
  end
end
