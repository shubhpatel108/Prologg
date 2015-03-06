class CreateTwitterLinks < ActiveRecord::Migration
  def up
    create_table :twitter_links do |t|
  		t.string :user_id,			null: false
  		t.string :url,				null: false
    end
  end

  def down
  	drop_table :twitter_links
  end
end
