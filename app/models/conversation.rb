class Conversation < ApplicationRecord
  belongs_to :user, foreign_key: :user_id, class_name: 'User'
  belongs_to :client, foreign_key: :client_id, class_name: 'User'

  has_many :messages, dependent: :destroy
  validates_uniqueness_of :user_id, scope: :client_id
  scope :between, -> (user_id,client_id) do
    where("(conversations.user_id = ? AND conversations.client_id = ?) OR (conversations.user_id = ? AND conversations.client_id = ?)", user_id, client_id, user_id, client_id)
  end
end
