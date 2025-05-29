class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line
    omniauth = request.env['omniauth.auth']
    provider = omniauth['provider']
    uid = omniauth['uid']
    info = omniauth['info']
    email = info['email'] || fake_email(uid, provider)

    # email を優先して既存ユーザーを検索し、次に provider + uid を試す
    user = User.find_by(email: email) || User.find_by(provider: provider, uid: uid)

    if user.nil?
      # 新規ユーザー（仮登録）
      user = User.new(
        provider: provider,
        uid: uid,
        email: email,
        password: Devise.friendly_token[0, 20],
        position_id: 13
      )
      user.set_values(omniauth) if user.respond_to?(:set_values)
      user.skip_confirmation!
      user.confirmed_at ||= Time.current
      user.save(validate: false)

      # プロフィール補完画面へリダイレクト
      session[:user_id] = user.id
      redirect_to complete_profile_path and return
    end

    # 既存ユーザー → ログイン後トップページへ
    sign_in user
    redirect_to root_path, notice: "ログインしました"
  end

  private

  def fake_email(uid, provider)
    "#{uid}-#{provider}@example.com"
  end
end
