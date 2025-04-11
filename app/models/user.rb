class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,  # このモジュールは、ユーザーが提供したパスワードを安全なハッシュに変換してデータベースに保存します。また、ユーザーがサインインする際のバリデーションも行います
         :registerable, # ユーザーがアプリにアカウントを登録できるようにし、ユーザーによるアカウントの編集や削除も処理します。
         :recoverable, # パスワードのリセットとアカウントの復旧を処理します。
         :rememberable, # アカウント作成時にユーザーが提供するメールアドレスやパスワードをカスタムバリデーションするルールを定義できます。
         :validatable, # ユーザーの認証中に、ユーザーをcookieで記憶します（ログインを保存）。
         :confirmable

    validates :first_name, presence: true, length: { maximum: 255 }
    validates :last_name, presence: true, length: { maximum: 255 }
    validates :email, presence: true, uniqueness: true

    has_many :trainings,  dependent:  :destroy
    belongs_to :position
    belongs_to :team
end
