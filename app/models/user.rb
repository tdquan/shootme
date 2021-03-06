class User < ApplicationRecord
  # mailer
  after_create :send_welcome_email
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # require 'elasticsearch/model'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         ##facebook & google
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  ## geocoding
  geocoded_by :address
  after_validation :geocode, if: :address_changed?


  ## Search
  include PgSearch
  pg_search_scope :query_search,
                  against: [:first_name, :last_name, :email],
                  using: {
                    tsearch: {
                      prefix: true,
                      dictionary: "english",
                      highlight: {
                        start_sel: "<b class='text-green'>",
                        stop_sel: "</b>"
                      }
                    }
                  }

  pg_search_scope :search_by_location,
                  against: :city,
                  using: {
                    tsearch: {
                      prefix: true
                    }
                  }

  pg_search_scope :search_by_profession,
                  against: :role,
                  using: {
                    tsearch: {
                      prefix: true,
                      any_word: true
                    }
                  }

  ## Albums
  has_many :albums
  accepts_nested_attributes_for :albums

  ## Avatar
  has_attachment :avatar, accept: [:jpg, :png, :gif]

  ## Requests
  has_many :requests_to_others,
           class_name: "Request",
           foreign_key: :client_id,
           dependent: :destroy
  has_many :requests_to_self,
           class_name: "Request",
           foreign_key: :user_id,
           dependent: :destroy

  has_many :bookings_to_self, through: :requests_to_self, source: :booking
  has_many :bookings_to_others, through: :requests_to_others, source: :booking

  ## Conversations
  has_many :conversations_as_user, class_name: 'Conversation', foreign_key: 'user_id'
  has_many :conversations_as_client, class_name: 'Conversation', foreign_key: 'client_id'
  has_many :messages

  ## Wallet
  has_one :wallet,
          dependent: :destroy

  ## Elasticsearch
  # include Elasticsearch::Model
  # include Elasticsearch::Model::Callbacks

  # searchkick

  ## Facebook Connect
  def self.find_for_facebook_oauth(auth)
    user_params = auth.to_h.slice(:provider, :uid)
    user_params.merge! auth.info.slice(:email, :first_name, :last_name)
    user_params[:facebook_picture_url] = auth.info.image
    user_params[:token] = auth.credentials.token
    user_params[:token_expiry] = Time.at(auth.credentials.expires_at)
    user_params[:password] = "123456"  # Fake password for validation

    user = User.find_or_create_by(provider: auth.provider, uid: auth.uid)
    user ||= User.where(email: auth.info.email).first # User did a regular sign up in the past.
    if user
      user.update(user_params)
    else
      user = User.new(user_params)
      user.save
      user.wallet = Wallet.create!
    end
    user
  end

  ## Google Auth
  def self.find_for_google_oauth(access_token)
    data = access_token.info
    user = User.where(:email => data["email"]).first

    # Uncomment the section below if you want users to be created if they don't exist
    unless user
      user = User.create(first_name: data["first_name"],
        last_name: data["last_name"],
        email: data["email"],
        password: "123456"
        # photo: "https://www.google.com/s2/photos/profile/#{user.id}"
      )
      user.wallet = Wallet.create!
    end
    user
  end

  def self.user_picture
    user = User.find(self.id)
    if user.facebook_picture_url
      user.avatar = user.facebook_picture_url
    elsif user.photo
     user.avatar = user.photo
    end
    user.avatar
  end

  def count_reviews
    requests = Request.where(user: self)
    review_count = 0
    if requests
      requests.each do |r|
        if r.booking
          if r.booking.review
            review_count += 1
          end
        end
      end
    end
    review_count
  end

  def average_rating
    requests = Request.where(user: self)
    ratings = []
    av_rating = 0
    if requests
      requests.each do |r|
        if r.booking
          if r.booking.review
            ratings << r.booking.review.rating
            av_rating = ratings.sum / ratings.size.to_i
          end
        end
      end
    end
    av_rating
  end

  private

  def send_welcome_email
    HomePageMailer.welcome(self).deliver_now
  end
end


# User.import force: true   # for auto sync model with elastic search

