class NotificationMailer < ApplicationMailer
    default from: ENV["GMAIL_USERNAME"]

    def remind_user_to_train(user)
      @user = user
      mail(
        to: @user.email,
        subject: "FTT 先週トレーニングが登録されていません"
      )
    end
end
