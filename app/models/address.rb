class Address < ApplicationRecord
  belongs_to :contact

  validates :city, presence: true
  validates :street_number, numericality: { only_integer: true }
end
