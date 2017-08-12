class AddApiCalledCountToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :api_called_count, :integer
  end
end
