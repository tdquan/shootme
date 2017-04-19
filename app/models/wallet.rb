class Wallet < ApplicationRecord
  belongs_to :user

  monetize :amount_cents, allow_nil: false
end
