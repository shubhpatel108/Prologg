class AddMetadataToCodeforcesProfile < ActiveRecord::Migration
  def up
  	add_column :codeforces_profiles, :metadata, :json, default: {} 
  end

  def down
  	remove_column :codeforces_profiles, :metadata
  end
end
