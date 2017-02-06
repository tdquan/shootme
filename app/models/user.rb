class User < ApplicationRecord
  require 'elasticsearch/model'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
end

User.import force: true# for auto sync model with elastic search
