class OrdersController < ApplicationController
  before_action :authenticate_user! # 条件：ログアウト状態ならログインページへ
  before_action :set_item, only: [:index, :create] # 商品情報を取得
  before_action :prevent_access # 条件：自身の出品 or 売却済みならトップへ

  def index
    @order_address = OrderAddress.new
  end

  def create
    @order_address = OrderAddress.new(order_params)
    if @order_address.valid?
      pay_item # 切り出したメソッドを呼び出す
      @order_address.save
      redirect_to root_path
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def order_params
    # フォームから送られてくる住所情報 + user_id, item_id, token をまとめる
    params.require(:order_address).permit(:postal_code, :prefecture_id, :city, :house_number, :building_name, :telephone_number).merge(
      user_id: current_user.id, item_id: params[:item_id], token: params[:token]
    )
  end

  def pay_item
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    Payjp::Charge.create(
      amount: @item.price,          # あなたの環境では @item.price が確実です
      card: order_params[:token],   # order_params からトークンを取得
      currency: 'jpy'
    )
  end

  def set_item
    @item = Item.find(params[:item_id])
  end

  def prevent_access
    # 条件：出品者本人である、または、すでに売却済みである場合
    return unless current_user.id == @item.user_id || @item.order.present?

    redirect_to root_path
  end
end
