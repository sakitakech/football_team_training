class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,  # このモジュールは、ユーザーが提供したパスワードを安全なハッシュに変換してデータベースに保存します。また、ユーザーがサインインする際のバリデーションも行います
         :registerable, # ユーザーがアプリにアカウントを登録できるようにし、ユーザーによるアカウントの編集や削除も処理します。
         :recoverable, # パスワードのリセットとアカウントの復旧を処理します。
         :rememberable, # アカウント作成時にユーザーが提供するメールアドレスやパスワードをカスタムバリデーションするルールを定義できます。
         :validatable, # ユーザーの認証中に、ユーザーをcookieで記憶します（ログインを保存）。
         :confirmable,
         :omniauthable, omniauth_providers: %i[line]

    validates :first_name, presence: true, length: { maximum: 255 }
    validates :last_name, presence: true, length: { maximum: 255 }
    validates :email, presence: true, uniqueness: true

    has_many :trainings,  dependent:  :destroy
    belongs_to :position
    belongs_to :team, optional: true
    has_many :team_join_requests

    enum :role, { member: 0, admin: 1 }

    def full_name
      "#{last_name}#{first_name}"
    end

    def self.ransackable_associations(auth_object = nil)
      [ "position" ]
    end

    def self.ransackable_attributes(auth_object = nil)
      [ "first_name", "last_name", "full_name", "position_id" ]
    end

    ransacker :full_name do
      Arel.sql("CONCAT(users.last_name, users.first_name)")
    end


    def social_profile(provider)
      social_profiles.select { |sp| sp.provider == provider.to_s }.first
    end

    def set_values(omniauth)
      return if provider.to_s != omniauth["provider"].to_s || uid != omniauth["uid"]
      credentials = omniauth["credentials"]
      info = omniauth["info"]

      access_token = credentials["refresh_token"]
      access_secret = credentials["secret"]
      credentials = credentials.to_json
      if info["name"].present?
        full_name = info["name"]
        self.last_name, self.first_name = full_name.split(" ", 2) # 名前を空白で分割
        self.first_name ||= "未設定"  # 万が一分割できなかった時用
        self.last_name  ||= "未設定"
      end
    end

    def set_values_by_raw_info(raw_info)
      self.raw_info = raw_info.to_json
      self.save!
    end

    def only_one_admin?
      User.where(team_id: self.team_id, role: "admin").count == 1
    end
end
