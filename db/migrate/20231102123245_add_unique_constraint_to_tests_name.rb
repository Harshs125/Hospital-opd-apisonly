class AddUniqueConstraintToTestsName < ActiveRecord::Migration[7.1]
  def change
    add_index :tests, :name, unique: true
  end
end
