class RefineCodeforcesProfile < ActiveRecord::Migration
  def up
  	remove_column :codeforces_profiles, :contribution
  	remove_column :codeforces_profiles, :rank
  	remove_column :codeforces_profiles, :max_rank
  	remove_column :codeforces_profiles, :rating
  	remove_column :codeforces_profiles, :max_rating
  	remove_column :codeforces_profiles, :last_online
  	rename_column :codeforces_profiles, :metadata, :data
  end

  def down
  	add_column :codeforces_profiles, :contribution
  	add_column :codeforces_profiles, :rank
  	add_column :codeforces_profiles, :max_rank
  	add_column :codeforces_profiles, :rating
  	add_column :codeforces_profiles, :max_rating
  	add_column :codeforces_profiles, :last_online
  	rename_column :codeforces_profiles, :data, :metadata
  end
end
