class AddLocationIdToUsers < ActiveRecord::Migration
  def up
  	add_column :users, :location_id, :integer
  end

  def down
  	remove_column :users, :location_id
  end
end
