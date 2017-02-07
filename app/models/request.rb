class Request < ApplicationRecord
  belongs_to :user, class_name: "User"
  belongs_to :client, class_name: "User"

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :location, presence: true
end
