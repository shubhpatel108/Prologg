class CreateMailNotifications < ActiveRecord::Migration
  def up
    create_table :mail_notifications do |t|
    	t.integer :sender_id,   null: false
    	t.integer :receiver_id, null: false
    	t.boolean :status, default: false
      t.timestamps
    end
  end
  def down
  	drop_table :mail_notifications
  end	
end
