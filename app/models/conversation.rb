class Conversation < ApplicationRecord
  belongs_to :user, foreign_key: :user_id, class_name: 'User'
  belongs_to :client, foreign_key: :client_id, class_name: 'User'

  has_many :messages, dependent: :destroy
  scope :between, -> (user_id,client_id) do
    where("(conversations.user_id = ? AND conversations.client_id = ?) OR (conversations.user_id = ? AND conversations.client_id = ?)", user_id, client_id, user_id, client_id)
  end

  def self.unread_count(user)
    i = 0
    Conversation.where(user_id: user.id).or(Conversation.where(client_id: user.id)).each do |c|
      if !c.messages.last.nil? && c.messages.last.user_id != user.id && c.messages.last.read == false
        i += 1
      end
    end
    return i
  end
end
