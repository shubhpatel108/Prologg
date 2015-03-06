class CreateGplusLinks < ActiveRecord::Migration
  def up
    create_table :gplus_links do |t|
  		t.string :user_id,			null: false
  		t.string :url,					null: false
    end
  end

  def down
  	drop_table :gplus_links
  end
end
