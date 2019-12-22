class User < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip
  validates_confirmation_of :password
  validates :email, uniqueness: true, presence: true
  has_many :orders, dependent: :destroy
  
  belongs_to :merchant, optional: true 

  has_secure_password

  enum role: ['default', 'admin', 'merchant']
end
