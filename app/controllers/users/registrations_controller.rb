# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  before_action :authenticate_user!
  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  def new_member
    build_resource({})
    resource.role = :member
    render :new_member
  end

  # def create
  #   super do |resource|
  #     # 管理者用登録画面から来ていたら admin にする
  #     if request.path == new_admin_registration_path
  #       resource.role = :admin
  #       resource.save
  #     end
  #   end
  # end
  def create
    build_resource(sign_up_params)
    # User.newと同じ

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length

      # roleに応じてそれぞれのビューに戻す
      case resource.role
      when "admin"
        render :new_admin, status: :unprocessable_entity
      else
        render :new_member, status: :unprocessable_entity
      end
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  def destroy
    if current_user.admin? && only_one_admin?(current_user)
      redirect_to confirm_delete_user_path, alert: "チームに1人しか管理者がいないため、アカウントを削除できません。"
      return
    end

    current_user.destroy
    redirect_to root_path, notice: "アカウントを削除しました。"
  end


  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  def confirm_delete
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  private

  def only_one_admin?(user)
      User.where(team_id: current_user.team_id, role: "admin").count == 1
  end
end
