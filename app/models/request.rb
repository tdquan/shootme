class Request < ApplicationRecord
  belongs_to :user, class_name: "User"
  belongs_to :client, class_name: "User"
  has_one :booking

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :location, presence: true

  monetize :price_cents

  # Geocoding
  geocoded_by :address
  after_validation :geocode, if: :location_changed?

  # return location as adrress to fix geocoding problem
  def address
    self.location
  end

  def get_review
    if self
      if booking
        self.booking.review
      end
    end
  end

end
