class AddIsValidToDoctors < ActiveRecord::Migration[7.1]
  def change
    add_column :doctors, :is_valid, :boolean, default: false
  end
end
