class CreateTrainings < ActiveRecord::Migration[7.2]
  def change
    create_table :trainings do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :datetime
      t.string :part
      t.text :content
      t.text :memo
      t.integer :body_weight
      t.integer :body_fat

      t.timestamps
    end
  end
end
