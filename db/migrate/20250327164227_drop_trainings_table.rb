class DropTrainingsTable < ActiveRecord::Migration[7.2]
  def change
    drop_table :trainings
  end
end
