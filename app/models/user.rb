class User < ApplicationRecord
  require 'elasticsearch/model'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         ##facebook
         :omniauthable, omniauth_providers: [:facebook]


  # Bookings
  has_many :bookings_to_others,
           class_name: "Booking",
           foreign_key: :client_id,
           dependent: :destroy
  has_many :bookings_to_self,
           class_name: "Booking",
           foreign_key: :user_id,
           dependent: :destroy

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

  # Facebook
  def self.find_for_facebook_oauth(auth)
    user_params = auth.to_h.slice(:provider, :uid)
    user_params.merge! auth.info.slice(:email, :first_name, :last_name)
    user_params[:facebook_picture_url] = auth.info.image
    user_params[:token] = auth.credentials.token
    user_params[:token_expiry] = Time.at(auth.credentials.expires_at)

    user = User.where(provider: auth.provider, uid: auth.uid).first
    user ||= User.where(email: auth.info.email).first # User did a regular sign up in the past.
    if user
      user.update(user_params)
    else
      user = User.new(user_params)
      user.password = Devise.friendly_token[0,20]  # Fake password for validation
      user.save
    end
    user
  end
end

User.import force: true# for auto sync model with elastic search
