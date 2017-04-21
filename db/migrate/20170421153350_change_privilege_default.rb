class ChangePrivilegeDefault < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :privilege, :integer, :default => 1
  end
end
