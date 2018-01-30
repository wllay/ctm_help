class User < ApplicationRecord
  validates :phone_number, phone: true
end
