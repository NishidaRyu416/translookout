class RemoveCustomerIdCheckFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :customer_id_check, :string
  end
end
