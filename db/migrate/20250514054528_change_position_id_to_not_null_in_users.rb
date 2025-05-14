class ChangePositionIdToNotNullInUsers < ActiveRecord::Migration[8.0]
  def change
    change_column_null :users, :position_id, false
  end
end
