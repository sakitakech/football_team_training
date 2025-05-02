class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redirect_admin_to_team_creation

  protected


  def redirect_admin_to_team_creation
    return unless user_signed_in?
    return unless current_user.admin?
    return if current_user.team_id.present?
    return if request.path == new_team_path
    return if devise_controller? # ← Deviseのログイン・登録画面では実行しない

    redirect_to new_team_path, alert: "まずはチームを作成してください"
  end

  def configure_permitted_parameters
    # 新規登録用
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :first_name, :last_name, :position_id, :team_id, :role ])

    # プロフィール編集用（任意）
    # devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end

  def after_sign_in_path_for(resource)
    trainings_path  # ← 任意のルートに変更可能
  end
end
