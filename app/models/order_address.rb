class OrderAddress
  include ActiveModel::Model
  attr_accessor :user_id, :item_id, :postal_code, :prefecture_id, :city, :house_number, :building_name, :telephone_number, :token

  with_options presence: true do
    validates :user_id
    validates :item_id
    validates :postal_code, format: { with: /\A[0-9]{3}-[0-9]{4}\z/, message: "is invalid. Include hyphen(-)"}
    validates :prefecture_id, numericality: { other_than: 1, message: "can't be blank"}
    validates :city
    validates :house_number
    validates :telephone_number, format: { with: /\A[0-9]{10,11}\z/, message: "is invalid"}
    validates :token # クレジットカード決済用のトークン
  end

  def save
    # 購入記録を保存し、変数orderに代入
    order = Order.create(user_id: user_id, item_id: item_id)
    # 配送先を保存
    # order_idには、今作成したorderのidを指定する
    ShippingAddress.create(postal_code: postal_code, prefecture_id: prefecture_id, city: city, house_number: house_number,
                           building_name: building_name, telephone_number: telephone_number, order_id: order.id)
  end
end
