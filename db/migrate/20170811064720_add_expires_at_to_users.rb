class AddExpiresAtToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :expires_at, :string
  end
end
