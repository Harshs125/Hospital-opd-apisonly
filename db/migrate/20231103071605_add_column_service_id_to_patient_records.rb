class AddColumnServiceIdToPatientRecords < ActiveRecord::Migration[7.1]
  def change
    add_column :patient_records, :service_id, :integer
    add_foreign_key :patient_records, :services, column: :service_id
  end
end
