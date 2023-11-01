class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable,jwt_revocation_strategy:self
  # enum role: { admin: 0, doctor: 1 }

  validates :email, presence: true, uniqueness: true
  def jwt_payload
    super 
  end
end
