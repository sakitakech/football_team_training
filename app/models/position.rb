class Position < ApplicationRecord
    has_many :user, dependent: :destroy
end
  