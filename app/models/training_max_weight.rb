class TrainingMaxWeight < ApplicationRecord
    belongs_to :max_weight
    belongs_to :training
    validates :record, numericality: { less_than: 10_000, allow_blank: true }
end
