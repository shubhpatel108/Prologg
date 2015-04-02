class CreateLocations < ActiveRecord::Migration
  def up
    create_table :locations do |t|
    	t.string :name
    	t.string :latitude
    	t.string :longitude

      t.timestamps
    end

    add_index :locations, :name
  end

  def down
  	drop_table :locations
  end
end
