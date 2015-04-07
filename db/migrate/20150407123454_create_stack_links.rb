class CreateStackLinks < ActiveRecord::Migration
  def up
    create_table :stack_links do |t|
  		t.string :user_id,			null: false
  		t.string :url,				null: false
    end
  end

  def down
  	drop_table :stack_links
  end
end
