class Patient < ApplicationRecord
    has_many :patient_records
    validates :name,:email,:mobile, presence: true 
    validates :email, uniqueness: true
end
