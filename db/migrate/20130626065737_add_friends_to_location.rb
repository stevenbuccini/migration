class AddFriendsToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :friend_id, :integer
  end
end
