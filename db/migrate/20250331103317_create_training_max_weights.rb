class CreateTrainingMaxWeights < ActiveRecord::Migration[7.2]
  def change
    create_table :training_max_weights do |t|

      t.integer :record

      t.references :training, foreign_key: true, null: false


      t.timestamps
    end
  end
end
