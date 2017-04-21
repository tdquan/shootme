class JobCode < ApplicationRecord
  belongs_to :booking

  def self.generate_code
    Digest::SHA1.hexdigest([Time.now, rand].join)
  end
end
