class CreateCodeforcesProfiles < ActiveRecord::Migration
  def up
    create_table :codeforces_profiles do |t|
    	t.integer :user_id, 					null: false
    	t.string :handle, 						null: false, default: ""
    	t.integer :contribution,			null: false, default: 0
    	t.string :rank,								null: false, default: ""
    	t.string :max_rank,						null: false, default: ""
    	t.integer :rating,						null: false, default: 0
    	t.integer :max_rating,				null: false, default: 0
    	t.datetime :last_online,			null: false

      t.timestamps
    end
  end

  def down
  	drop_table :codeforces_profiles
  end
end
