class CreateWebsiteLinks < ActiveRecord::Migration
  def up
    create_table :website_links do |t|
  		t.string :user_id,			null: false
  		t.string :url,				null: false
    end
  end

  def down
  	drop_table :website_links
  end
end
