class ChangeCulumns < ActiveRecord::Migration[7.2]
  def change
    change_column :training_max_weights, :record, :decimal, precision: 7, scale: 2
  end
end
