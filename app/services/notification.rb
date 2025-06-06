class Notification
    def self.check_training_inactivity
      User.find_each do |user|
        last_training = user.trainings.order(datetime: :desc).first
        if last_training.nil? || last_training.datetime < 4.week.ago
          NotificationMailer.remind_user_to_train(user).deliver_now
        end
      end
    end
end
