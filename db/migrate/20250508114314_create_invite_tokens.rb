class CreateInviteTokens < ActiveRecord::Migration[8.0]
  def change
    create_table :invite_tokens do |t|
      t.string :token
      t.datetime :expires_at
      t.references :team, null: false, foreign_key: true

      t.timestamps
    end
  end
end
