class RenameSessionsToTrainings < ActiveRecord::Migration[7.2]
  def change
    rename_table :sessions, :trainings
  end
end
