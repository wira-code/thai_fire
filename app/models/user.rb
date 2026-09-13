class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :nullify
  has_many :reservations

    enum :role, {
      customer: 0,
      admin: 1,
      kitchen: 2,
      driver: 3
    }, validate: true

  validates :first_name, presence: true
  validates :last_name, presence: true
  # validates :role, presence: true
end
