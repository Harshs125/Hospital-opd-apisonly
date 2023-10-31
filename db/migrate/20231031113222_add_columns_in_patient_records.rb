class AddColumnsInPatientRecords < ActiveRecord::Migration[7.1]
  def change
    add_column :patient_records, :diagnosed_with, :string
    add_column :patient_records, :diagnosed_by, :integer
    add_column :patient_records, :prescription, :string
    add_foreign_key :patient_records  , :doctors, column: :diagnosed_by
  end
end
