class AddDoctorIdToDoctors < ActiveRecord::Migration[7.1]
  def change
    add_column :doctors,:doctor_id,:integer,default: nil
  end
end
