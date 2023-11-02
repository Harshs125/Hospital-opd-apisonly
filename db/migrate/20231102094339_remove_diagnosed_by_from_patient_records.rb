class RemoveDiagnosedByFromPatientRecords < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :patient_records, :doctors, column: :diagnosed_by
    remove_column :patient_records, :diagnosed_by, :integer
  end
end
