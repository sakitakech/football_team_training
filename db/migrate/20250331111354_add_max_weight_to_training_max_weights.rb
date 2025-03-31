class AddMaxWeightToTrainingMaxWeights < ActiveRecord::Migration[7.2]
  def change
    add_reference :training_max_weights, :max_weight, null: false, foreign_key: true
  end
end
