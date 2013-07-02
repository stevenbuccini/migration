class RemoveLocationidfromuser < ActiveRecord::Migration
  def up
  	remove_column :users, :location_id
  end

  def down
  end
end
