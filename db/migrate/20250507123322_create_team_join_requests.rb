class CreateTeamJoinRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :team_join_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.string :token
      t.datetime :expires_at
      t.text :message
      t.integer :status

      t.timestamps
    end
  end
end
