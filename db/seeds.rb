# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# == ポジション（Position）==
positions = [
  { id: 1,  name: "Quarterback",       short_name: "QB" },
  { id: 2,  name: "Wide Receiver",     short_name: "WR" },
  { id: 3,  name: "Running Back",      short_name: "RB" },
  { id: 4,  name: "Offensive Lineman", short_name: "OL" },
  { id: 5,  name: "Tight End",         short_name: "TE" },
  { id: 6,  name: "Defensive Lineman", short_name: "DL" },
  { id: 7,  name: "Linebacker",        short_name: "LB" },
  { id: 8,  name: "Cornerback",        short_name: "CB" },
  { id: 9,  name: "Safety",            short_name: "SF" },
  { id: 10, name: "Kicker",            short_name: "K" },
  { id: 11, name: "Punter",            short_name: "P" },
  { id: 12, name: "Snapper",           short_name: "SN" },
  { id: 13, name: "Others",            short_name: "OTHERS" }
]

positions.each do |pos|
  Position.find_or_initialize_by(id: pos[:id]).tap do |p|
    p.name = pos[:name]
    p.short_name = pos[:short_name]
    p.save!
  end
end

puts "✅ ポジションデータを作成または更新しました"

# == トレーニング種目（MaxWeight）==
max_weights = %w[ベンチプレス スクワット デッドリフト クリーン]

max_weights.each do |name|
  MaxWeight.find_or_create_by!(name: name)
end

puts "✅ トレーニング種目を作成しました"

# == リーグ（League）==
leagues = [
  "Xleague",
  "プライベートリーグ",
  "KCFA（大学）",
  "高校",
  "その他"
]

leagues.each do |name|
  League.find_or_create_by!(name: name)
end

puts "✅ リーグを作成しました"
