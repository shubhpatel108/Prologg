class AddViewCount < ActiveRecord::Migration
  def up

    add_column :users, :view_count, :integer, default: 0
  end

  def down
  	remove_column :users, :view_count
  end
end
