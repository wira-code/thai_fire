class Address < ApplicationRecord
  belongs_to :user

  validates :label, presence: true
  validates :full_name, presence: true
  validates :phone, presence: true
  validates :address_line1, presence: true
  validates :city, presence: true
  validates :postal_code, presence: true
  validates :country, presence: true
  validates :latitude, numericality: { greater_than_or_equal_to: -90,
             less_than_or_equal_to: 90 }, allow_nil: true
  validates :longitude, numericality: { greater_than_or_equal_to: -180,
             less_than_or_equal_to: 180 }, allow_nil: true
end
