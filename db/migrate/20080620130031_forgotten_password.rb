class ForgottenPassword < ActiveRecord::Migration
  def self.up
    add_column :users, :forgotten_password_link, :string
    add_index :users, :email
    add_index :users, :forgotten_password_link
  end

  def self.down
    remove_index :users, :email
    remove_index :users, :forgotten_password_link
    remove_column :users, forgotten_password_link

  end
end
