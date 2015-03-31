class CreateLinkedinProfiles < ActiveRecord::Migration
  def up
    create_table :linkedin_profiles do |t|
    	t.integer :user_id,         null: false
      t.string :uid,              null: false
      t.string :token,            null: false
    	t.string :secret,           null: false
    	t.json :data
      t.timestamps
    end
  end

	def down
		drop_table :linkedin_profiles
	end
end
