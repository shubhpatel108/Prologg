class CreateLanguagesUsers < ActiveRecord::Migration
  def change
    create_table :languages_users, id: false do |t|
    	t.belongs_to :language, index: true
    	t.belongs_to :user, index: true
    end
  end
end
