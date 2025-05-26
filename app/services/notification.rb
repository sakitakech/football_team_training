class Notification
    def self.check_training_inactivity
      User.find_each do |user|
        last_training = user.trainings.order(datetime: :desc).first
        if last_training.nil? || last_training.datetime < 1.week.ago
          puts "メール送信対象者確認: #{user.last_name}   #{user.email}（ID: #{user.id}）"
          NotificationMailer.remind_user_to_train(user).deliver_now
          puts "送信済み"
        end
      end
    end
end
