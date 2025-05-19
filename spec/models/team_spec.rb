require 'rails_helper'

RSpec.describe Team, type: :model do
    describe "バリデーション" do
      let(:league) { League.first }  
  
      context "nameとleague_idが両方存在する場合" do
        it "有効である" do
          team = build(:team, name: "チームA", league_id: league.id)
          expect(team).to be_valid
        end
      end
  
      context "nameが空の場合" do
        it "無効である" do
          team = build(:team, name: nil, league_id: league.id)
          expect(team).not_to be_valid
        end
      end
  
      context "同じleague内で同じnameが存在する場合" do
        it "無効である" do
          create(:team, name: "チームA", league_id: league.id)
          duplicate_team = build(:team, name: "チームA", league_id: league.id)
          expect(duplicate_team).not_to be_valid
        end
      end
  
      context "異なるleagueで同じnameが存在する場合" do
        it "有効である" do
          other_league = League.find_by(name: "X1 Area") || League.where.not(id: league.id).first
          create(:team, name: "チームA", league_id: league.id)
          team_in_other_league = build(:team, name: "チームA", league_id: other_league.id)
          expect(team_in_other_league).to be_valid
        end
      end
    end
  end
  