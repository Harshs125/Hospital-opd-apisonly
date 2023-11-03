class AddUniqueConstraintToVaccinesName < ActiveRecord::Migration[7.1]
  def change
    add_index :Vaccines, :name, unique: true
  end
end
