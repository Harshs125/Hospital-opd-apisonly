class AddDiagnosedByToPatientRecords < ActiveRecord::Migration[7.1]
  def change
    add_column :patient_records, :diagnosed_by, :integer
    add_foreign_key :patient_records, :users, column: :diagnosed_by
  end
end
