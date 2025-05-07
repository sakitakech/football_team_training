module Api
    class ChartsController < ApplicationController
      before_action :set_user


      def max_weights
        training_max_weights = TrainingMaxWeight
          .joins(:training, :max_weight)
          .where(trainings: { user_id: @user.id })
          .where.not(record: nil)
          .order("trainings.datetime ASC")

        render json: training_max_weights.map { |mw|
          {
            date: mw.training.datetime.to_date,
            name: mw.max_weight.name,
            value: mw.record
          }
        }
      end

      def body_metrics
        trainings = Training
          .where(user_id: @user.id)
          .where.not(body_weight: nil).or(
            Training.where(user_id: @user.id).where.not(body_fat: nil)
          )
          .order(datetime: :asc)

        render json: trainings.map { |t|
          {
            date: t.datetime.to_date,
            weight: t.body_weight,
            body_fat: t.body_fat
          }
        }
      end

      private

      def set_user
        @user = User.find(params[:user_id])

        # ✅ チームに所属している場合だけチームIDを比較
        if current_user.team_id.present?
          if @user.team_id != current_user.team_id
      render json: { error: "他チームのデータにはアクセスできません" }, status: :forbidden
          end
        else
          # ✅ current_userがチーム未所属 → 自分以外のデータにはアクセスできない
          if @user.id != current_user.id
            render json: { error: "他ユーザーのデータにはアクセスできません" }, status: :forbidden
          end
        end
      end
    end
end
