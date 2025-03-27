class Training < ApplicationRecord
  belongs_to :user

  validates :datetime, presence: true
end
