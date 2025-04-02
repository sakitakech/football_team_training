class ChangeBodyWeightToDecimalInTrainings < ActiveRecord::Migration[7.2]
  def change
    change_column :trainings, :body_weight, :decimal, precision: 5, scale: 2
    change_column :trainings, :body_fat, :decimal, precision: 5, scale: 2
  end
end
