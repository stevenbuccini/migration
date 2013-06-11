class AddedBeenChecked < ActiveRecord::Migration
  def up
  end

  def down
  end

  def change
   
    add_column :users, :been_checked, :boolean
  end
end
