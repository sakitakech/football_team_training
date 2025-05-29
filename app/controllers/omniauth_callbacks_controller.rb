class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line
    omniauth = request.env['omniauth.auth']
    provider = omniauth['provider']
    uid = omniauth['uid']
    info = omniauth['info']
    email = info['email'] || "#{uid}-#{provider}@example.com"

    # provider + uid で既存ユーザーを検索
    user = User.find_by(provider: provider, uid: uid)

    if user.nil?
      # 新規ユーザーを作成（仮登録）
      user = User.new(
        provider: provider,
        uid: uid,
        email: email,
        password: Devise.friendly_token[0, 20],
        position_id: Position.first&.id || 13
      )
    end

    # 名前やその他の情報をセット（独自メソッド）
    user.set_values(omniauth) if user.respond_to?(:set_values)

    # 確認済み扱いにする（新規・既存問わず）
    user.skip_confirmation!
    user.confirmed_at ||= Time.current
    user.save(validate: false)

    # ログを確認したい場合（本番では不要）
    Rails.logger.debug "🔍 ユーザー情報: #{user.inspect}"
    Rails.logger.debug "✅ confirmed_at: #{user.confirmed_at}"
    Rails.logger.debug "✅ confirmed?: #{user.confirmed?}"

    # 仮プロフィールならプロフィール入力へ、そうでなければログイン
    if user.first_name == "未設定" || user.last_name == "未設定"
      session[:user_id] = user.id
      redirect_to complete_profile_path
    else
      sign_in_and_redirect user, event: :authentication
    end
  end
  
    private

    def basic_action
      @omniauth = request.env["omniauth.auth"]
      if @omniauth.present?
        @profile = User.find_or_initialize_by(provider: @omniauth["provider"], uid: @omniauth["uid"])
        if @profile.email.blank?
          email = @omniauth["info"]["email"] ? @omniauth["info"]["email"] : "#{@omniauth["uid"]}-#{@omniauth["provider"]}@example.com"
          @profile = current_user || User.create!(provider: @omniauth["provider"], uid: @omniauth["uid"], email: email, password: Devise.friendly_token[0, 20])
        end
        @profile.set_values(@omniauth)
        sign_in(:user, @profile)
      end
      flash[:notice] = "ログインしました"
      redirect_to root_path
    end

    def fake_email(uid, provider)
      "#{auth.uid}-#{auth.provider}@example.com"
    end
end
