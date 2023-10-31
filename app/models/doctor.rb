class Doctor < ApplicationRecord
    validates :name,:email,:mobile, presence: true
    validates :email, uniqueness: true
end
