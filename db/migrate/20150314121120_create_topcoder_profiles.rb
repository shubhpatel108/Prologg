class CreateTopcoderProfiles < ActiveRecord::Migration
  def up
    create_table :topcoder_profiles do |t|
      t.integer :user_id,          null: false
  		t.string :handle, 				  null: false
  		t.json :data, 						  null: false
      t.timestamps
    end
  end

  def down
  	drop_table :topcoder_profiles
  end

end
