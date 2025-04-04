class AddPositionToUsers < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :position, foreign_key: true, index: true
  end
end
