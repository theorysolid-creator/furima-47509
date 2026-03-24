class Item < ApplicationRecord
  # ActiveHashとの紐付け
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :condition
  belongs_to :postage
  belongs_to :prefecture
  belongs_to :shipping_date
  belongs_to :user

  has_one_attached :image
  has_one :order

  # 空の投稿を保存できないようにする
  validates :item_name, :description, :image, presence: true

  # ジャンルの選択が「---」の時は保存できないようにする
  validates :category_id, :condition_id, :postage_id, :prefecture_id, :shipping_date_id,
            numericality: { other_than: 1, message: "can't be blank" }

  # 価格の範囲設定
  validates :price, presence: true,
                    numericality: { only_integer: true, greater_than_or_equal_to: 300, less_than_or_equal_to: 9_999_999, allow_blank: true }
end
