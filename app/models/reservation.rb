# frozen_string_literal: true

class Reservation < ApplicationRecord
  ## Associations
  belongs_to :ticket

  ## Enums
  # Rails 6/7 default: :created
  enum status: { created: 0, booked: 1, cancelled: 2 }

  ## Validations
  validates :count, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :user_uid, presence: true
end
