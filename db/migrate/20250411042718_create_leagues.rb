class CreateLeagues < ActiveRecord::Migration[8.0]
  def change
    create_table :leagues do |t|
      t.string :name

      t.timestamps
    end
  end
end
