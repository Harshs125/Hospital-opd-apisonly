class AddUsernameRoleToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :username, :string
    add_column :users, :role, :string # 1 for default role (doctor)
    add_index :users, :username, unique: true
  end
end
