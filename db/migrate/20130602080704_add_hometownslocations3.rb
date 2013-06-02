class AddHometownslocations3 < ActiveRecord::Migration
  def change
    add_column :users, :hometowns, :array
    add_column :users, :locations, :array
  end
end
