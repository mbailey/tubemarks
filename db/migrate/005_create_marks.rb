class CreateMarks < ActiveRecord::Migration
  def self.up
    create_table :marks do |t|
      t.integer :video_id
      t.integer :user_id
      t.integer :rating
      t.integer :category
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :marks
  end
end
