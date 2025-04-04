class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # 新規登録用
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :first_name, :last_name, :position_id ])

    # プロフィール編集用（任意）
    # devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end

  def after_sign_in_path_for(resource)
    trainings_path  # ← 任意のルートに変更可能
  end
end
