class AddProfileUpdatedAtColumnToUsers < ActiveRecord::Migration
	def up
		add_column :users, :profile_updated_at, :datetime
	end

	def down
		remove_column :users, :profile_updated_at
	end
end
