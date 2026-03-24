class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new]

  def index
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path # 保存できたらトップへ
    else
      render :new # 保存できなければ出品画面を再表示
    end
  end

  private

  def item_params
    params.require(:item).permit(:image, :item_name, :description, :category_id, :condition_id, :postage_id, :prefecture_id, :shipping_date_id, :price).merge(user_id: current_user.id)
  end
end
