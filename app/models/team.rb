class Team < ApplicationRecord
  belongs_to :league
  has_many :users
  has_many :team_join_requests

  validates :name, presence: true
  validates :name, uniqueness: { scope: :league_id, message: "はこのリーグ内で既に使われています" }
end
