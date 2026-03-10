require 'rails_helper'

RSpec.describe Item, type: :model do
  before do
    @item = FactoryBot.build(:item)
  end

  describe '商品出品機能' do
    context '商品出品ができるとき' do
      it '全ての入力事項が正しく存在すれば出品できる' do
        expect(@item).to be_valid
      end
    end

    context '商品出品ができないとき' do
      it '商品画像が空では出品できない' do
        @item.image = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("Image を入力してください")
      end
      it '商品名が空では出品できない' do
        @item.item_name = ''
        @item.valid?
        expect(@item.errors.full_messages).to include("商品名 を入力してください")
      end
      it '商品の説明が空では出品できない' do
        @item.description = ''
        @item.valid?
        expect(@item.errors.full_messages).to include("商品の説明 を入力してください")
      end

      it 'カテゴリーの情報が未選択（idが1）では出品できない' do
        @item.category_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include("カテゴリー can't be blank")
      end

      it '価格の情報が空では出品できない' do
        @item.price = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("価格 を入力してください")
      end

      it '価格が300円未満では出品できない' do
        @item.price = 299
        @item.valid?
        expect(@item.errors.full_messages).to include("価格 is out of setting range")
      end

      it '価格が9,999,999円を超えると出品できない' do
        @item.price = 10_000_000
        @item.valid?
        expect(@item.errors.full_messages).to include("価格 is out of setting range")
      end

      it '商品の状態の情報が未選択（idが1）では出品できない' do
        @item.condition_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include("商品の状態 can't be blank")
      end

      it '配送料の負担の情報が未選択（idが1）では出品できない' do
        @item.postage_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include("配送料の負担 can't be blank")
      end

      it '発送元の地域の情報が未選択（idが1）では出品できない' do
        @item.prefecture_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include("発送元の地域 can't be blank")
      end

      it '発送までの日数の情報が未選択（idが1）では出品できない' do
        @item.shipping_date_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include("発送までの日数 can't be blank")
      end

      it '価格に半角数字以外が含まれていると出品できない' do
        @item.price = '３００' # 全角数字
        @item.valid?
        expect(@item.errors.full_messages).to include("価格 is out of setting range")
      end

      it 'userが紐付いていないと出品できない' do
        @item.user = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("User を入力してください")
      end
    end
  end
end