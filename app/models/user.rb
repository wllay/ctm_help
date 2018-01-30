class User < ApplicationRecord
  validates :phone_number, telephone_number: {types: [:fixed_line, :mobile]}
  #validates :phone_number, phone: true
end
