class CreatePatients < ActiveRecord::Migration[7.1]
  def change
    create_table :patients do |t|
      t.string :name
      t.string :email
      t.string :mobile

      t.timestamps
    end
  end
end
