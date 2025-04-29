module Api
    class CalendarController < ApplicationController
      before_action :authenticate_user! # 必要なら追加（Devise使ってるなら）
  
      def histories
        # 同じチームのメンバーだけ対象
        team_member_ids = User.where(team_id: current_user.team_id).pluck(:id)
  
        # contentが入ってるトレーニングだけ取得
        trainings = Training
                      .includes(:user)
                      .where(user_id: team_member_ids)
                      .where.not(content: nil)
                      .order(:datetime)
  
        events = trainings.map do |training|
          {
            date: training.datetime.to_date,
            name: training.user.last_name,
            user_id: training.user.id,
            position_id: training.user.position_id
          }
        end
  
        render json: events
      end
    end
  end
  