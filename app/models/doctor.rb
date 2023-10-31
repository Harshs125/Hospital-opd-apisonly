class Doctor < ApplicationRecord
    # serialize :specialization, Array,default: []
    before_validation :set_default_is_valid, on: :create
    validates :name,:email,:mobile, presence: true
    validates :email, uniqueness: true
    validates :is_valid, inclusion: { in: [true, false] }


    private
    def set_default_is_valid
        self.is_valid = false if self.is_valid.nil?
    end
end
