class ChangeHandleDatatypeInCodeforcesProfiles < ActiveRecord::Migration
	def up
  	change_column :codeforces_profiles, :handle, :string
  end

	def down
  	change_column :codeforces_profiles, :handle, :integer
  end
end
