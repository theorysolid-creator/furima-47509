class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy] # ログアウトならログイン画面へ
  before_action :set_item, only: [:edit, :update, :show, :destroy] # 重複を避ける共通処理
  before_action :move_to_index, only: [:edit, :update, :destroy] # 権限チェック

  def destroy
    if @item.destroy
      redirect_to root_path
    else
      render :show, status: :unprocessable_entity
    end
  end

  def index
    @items = Item.order('created_at DESC')
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    return unless @item.user_id != current_user.id || @item.order.present?

    redirect_to root_path
  end

  def update
    if @item.update(item_params)
      redirect_to item_path(@item.id) # 編集完了後は詳細ページへ
    else
      render :edit, status: :unprocessable_entity # 失敗時はエラー表示して戻す
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def move_to_index
    # 「自分ではない」または「売却済み（※購入機能実装後）」ならトップへ
    # ※ 現時点では @item.order.present? などは無しでOK
    return unless current_user.id != @item.user_id

    redirect_to root_path
  end

  def item_params
    params.require(:item).permit(:image, :item_name, :description, :category_id, :condition_id, :postage_id, :prefecture_id,
                                 :shipping_date_id, :price).merge(user_id: current_user.id)
  end
end
