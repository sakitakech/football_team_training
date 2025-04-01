class CreateMaxWeights < ActiveRecord::Migration[7.2]
  def change
    create_table :max_weights do |t|
      t.string :name

      t.timestamps
    end

   add_index :max_weights, :name
  end
end
