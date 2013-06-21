class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.string :name
      t.string :image
      t.string :current
      t.string :hometown
      t.integer :hometown_latitude
      t.integer :hometown_longitude
      t.integer :current_latitude
      t.integer :current_longitude

      t.timestamps
    end
  end
end
