class RemovePatientIdColumnFromPatientRecords < ActiveRecord::Migration[7.1]
  def change
    remove_column :patient_records, :patient_id
  end
end
