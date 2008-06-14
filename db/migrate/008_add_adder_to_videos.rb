class AddAdderToVideos < ActiveRecord::Migration
  def self.up
    add_column :videos, :adder, :integer
  end

  def self.down
    remove_column :videos, :adder
  end
end
