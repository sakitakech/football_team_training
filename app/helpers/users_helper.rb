module UsersHelper
    def only_one_admin?(user)
        User.where(team_id: current_user.team_id, role: "admin").count == 1
      end
end
