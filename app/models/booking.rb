class Booking < ApplicationRecord
  # belongs_to :user, class_name: "User"
  # belongs_to :client, class_name: "User"
  belongs_to :request
  has_one :review
  has_one :job_code

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :location, presence: true

  monetize :price_cents
end
