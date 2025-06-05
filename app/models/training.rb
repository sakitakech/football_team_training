class Training < ApplicationRecord
  belongs_to :user
  has_many :training_max_weights, dependent: :destroy

  validates :datetime, presence: true

  validates :body_weight, numericality: { less_than: 1000, allow_blank: true }
  validates :body_fat, numericality: { less_than: 100, allow_blank: true }

  accepts_nested_attributes_for :training_max_weights, allow_destroy: true

end
