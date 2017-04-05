class Request < ApplicationRecord
  belongs_to :user, class_name: "User"
  belongs_to :client, class_name: "User"
  has_one :booking

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :location, presence: true

  monetize :price_cents

  def get_review
    if self
      if booking
        self.booking.review
      end
    end
  end

end
