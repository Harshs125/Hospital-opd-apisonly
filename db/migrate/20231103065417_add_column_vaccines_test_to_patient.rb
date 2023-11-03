class AddColumnVaccinesTestToPatient < ActiveRecord::Migration[7.1]
  def change
    add_column :patient_records, :vaccine_id, :integer
    add_foreign_key :patient_records, :vaccines, column: :vaccine_id
    add_column :patient_records, :test_id, :integer
    add_foreign_key :patient_records, :tests, column: :test_id
  end
end
