class CreateViews < ActiveRecord::Migration
  def self.up
    create_table :views do |t|
      t.integer :user_id
      t.integer :video_id

      t.timestamps
    end
  end

  def self.down
    drop_table :views
  end
end
