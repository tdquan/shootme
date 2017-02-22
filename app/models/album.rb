class Album < ApplicationRecord
  has_attachments :photos
end
