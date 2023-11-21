class CreatePatientRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :patient_records do |t|
      t.integer :patient_id

      t.timestamps
    end
    add_index :patient_records, :patient_id
  end
end
 