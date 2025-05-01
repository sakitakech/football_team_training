module Api
    class CalendarController < ApplicationController
      before_action :authenticate_user! # 必要なら追加（Devise使ってるなら）
  
      def histories
        team_member_ids = User.where(team_id: current_user.team_id).pluck(:id)
      
        trainings = if params[:user_id].present?
                      Training.includes(:user)
                              .where(user_id: params[:user_id])
                              .where.not(content: nil)
                    else
                      Training.includes(:user)
                              .where(user_id: team_member_ids)
                              .where.not(content: nil)
                    end
      
        trainings = trainings.order(:datetime)
      
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
  