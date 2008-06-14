class AddPrivateToVideos < ActiveRecord::Migration
  def self.up
    add_column :videos, :private, :boolean, :default => false
  end

  def self.down
    remove_column :videos, :private
  end
end
