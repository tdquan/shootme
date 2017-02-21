class User < ApplicationRecord
  require 'elasticsearch/model'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Bookings
  has_many :bookings_to_others,
           class_name: "Booking",
           foreign_key: :client_id,
           dependent: :destroy
  has_many :bookings_to_self,
           class_name: "Booking",
           foreign_key: :user_id,
           dependent: :destroy

  # Albums
  has_many :albums

  # Avatar
  has_attachment :avatar, accept: [:jpg, :png, :gif]

  # Requests
  has_many :requests_to_others,
           class_name: "Request",
           foreign_key: :client_id,
           dependent: :destroy
  has_many :requests_to_self,
           class_name: "Request",
           foreign_key: :user_id,
           dependent: :destroy

  # Requests
  has_many :reviews, dependent: :destroy

  # Elasticsearch
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
end

User.import force: true   # for auto sync model with elastic search
