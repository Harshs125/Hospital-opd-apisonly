class ChangeFromTimeAndToTimeToString < ActiveRecord::Migration[7.1]
  def change
    change_column :doctors, :timing_from, :string
    change_column :doctors, :timing_to, :string
  end
end
