class RenameAvailibilityColumnInUsers < ActiveRecord::Migration
  def up
  	rename_column :users, :availibity, :availability
  end

  def down
  	rename_column :users, :availability, :availibity
  end
end
