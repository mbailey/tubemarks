class AddColumnsToVideo < ActiveRecord::Migration
  def self.up
    add_column :videos, :title, :string
    add_column :videos, :thumbnail_url, :string
    add_column :videos, :length_seconds, :integer
  end

  def self.down
    remove_column :videos, :length_seconds
    remove_column :videos, :thumbnail_url
    remove_column :videos, :title
  end
end
