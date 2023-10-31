class CreateDoctors < ActiveRecord::Migration[7.1]
  def change
    create_table :doctors do |t|
      t.string :name
      t.string :email
      t.string :mobile
      t.text :specialization
      t.time :timing_from,default:nil
      t.time :timing_to,default:nil

      t.timestamps
    end
  end
end
