class Training < ApplicationRecord
  belongs_to :user
  has_many :training_max_weights, dependent: :destroy

  validates :datetime, presence: true
  accepts_nested_attributes_for :training_max_weights, allow_destroy: true
end
