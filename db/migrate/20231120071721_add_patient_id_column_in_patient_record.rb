class AddPatientIdColumnInPatientRecord < ActiveRecord::Migration[7.1]
  def change
    add_reference :patient_records, :patient, foreign_key: true
  end
end
