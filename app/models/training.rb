class Training < ApplicationRecord
  belongs_to :user
  has_many :training_max_weights
  
  validates :datetime, presence: true
end
