# frozen_string_literal: true

class Contact < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  has_many :addresses
end
