class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :id
      t.string :latitude
      t.string :longitude

      t.timestamps
    end
  end
end
