class Album < ApplicationRecord
  has_attachments :photos
  belongs_to :user
end
