class CreateBlogLinks < ActiveRecord::Migration
  def up
    create_table :blog_links do |t|
  		t.string :user_id,			null: false
  		t.string :url,				null: false
    end
  end

  def down
  	drop_table :blog_links
  end
end
