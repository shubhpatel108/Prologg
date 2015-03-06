class CreateQuoraLinks < ActiveRecord::Migration
  def up
    create_table :quora_links do |t|
  		t.string :user_id,			null: false
  		t.string :url,				null: false
    end
  end

  def down
  	drop_table :quora_links
  end
end
