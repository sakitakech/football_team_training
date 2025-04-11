class Team < ApplicationRecord
  belongs_to :league
  has_many :users
end
