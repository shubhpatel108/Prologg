class CreateFacebookLinks < ActiveRecord::Migration
  def up
    create_table :facebook_links do |t|
  		t.string :user_id,			null: false
  		t.string :url,				null: false
    end
  end

  def down
  	drop_table :facebook_links
  end
end
