class AddConsultationChargeToDoctors < ActiveRecord::Migration[7.1]
  def change
    add_column :doctors, :consultation_charge, :integer, default: nil
  end
end
