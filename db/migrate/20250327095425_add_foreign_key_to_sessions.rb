class AddForeignKeyToSessions < ActiveRecord::Migration[7.2]
  def change
    add_foreign_key :sessions, :users
  end
end
