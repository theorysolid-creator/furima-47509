class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # --- バリデーションの設定 ---
  # 1. ニックネームが必須
  validates :nickname, presence: true

  # 2. パスワードは、半角英数字混合での入力が必須
  # 6文字以上のバリデーションはDeviseの標準機能に含まれています
  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i.freeze
  validates_format_of :password, with: PASSWORD_REGEX, message: 'は半角英数字混合で入力してください'

  # 3. お名前(全角)は、名字と名前がそれぞれ必須。全角（漢字・ひらがな・カタカナ）での入力が必須
  with_options presence: true, format: { with: /\A[ぁ-んァ-ヶ一-龥々ー]+\z/, message: 'は全角（漢字・ひらがな・カタカナ）で入力してください' } do
    validates :last_name
    validates :first_name
  end

  # 4. お名前カナ(全角)は、名字と名前がそれぞれ必須。全角（カタカナ）での入力が必須
  with_options presence: true, format: { with: /\A[ァ-ヶー]+\z/, message: 'は全角カタカナで入力してください' } do
    validates :last_name_kana
    validates :first_name_kana
  end

  # 5. 生年月日が必須
  validates :birth_date, presence: true

end
