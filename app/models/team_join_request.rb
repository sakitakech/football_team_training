class TeamJoinRequest < ApplicationRecord
  belongs_to :user
  belongs_to :team

  enum :status, { pending: 0, approved: 1, rejected: 2 }

  scope :active, -> { where("expires_at > ?", Time.current) }
end