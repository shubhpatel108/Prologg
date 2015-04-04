class AddTokenToGithubProfile < ActiveRecord::Migration
  def up
  	add_column :github_profiles, :token, :string
  end

  def down
  	remove_column :github_profiles, :token
  end
end
