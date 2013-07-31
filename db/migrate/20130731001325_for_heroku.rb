class ForHeroku < ActiveRecord::Migration
  def up
  	add_column :friends, :hometown, :string
  	add_column :friends, :current_location, :string
  end

  def down
  end
end
