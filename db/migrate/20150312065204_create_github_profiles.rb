class CreateGithubProfiles < ActiveRecord::Migration
  def up
    create_table :github_profiles do |t|
    	t.integer :user_id, null: false
    	t.string :username, null: false
    	t.json :data
      t.timestamps
    end
  end

  def down
  	drop_table :github_profiles
  end
end
