require 'rails_helper'

RSpec.describe OrderAddress, type: :model do
  before do
    user = FactoryBot.create(:user)
    item = FactoryBot.create(:item)
    @order_address = FactoryBot.build(:order_address, user_id: user.id, item_id: item.id)
  end

  describe '商品購入記録の保存' do
    context '内容に問題ない場合' do
      it 'すべての値が正しく入力されていれば保存できること' do
        expect(@order_address).to be_valid
      end
      it 'building_nameは空でも保存できること' do
        @order_address.building_name = ''
        expect(@order_address).to be_valid
      end
    end

    context '内容に問題がある場合' do
      it 'postal_codeが空だと保存できないこと' do
        @order_address.postal_code = ''
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('郵便番号 を入力してください', '郵便番号 はハイフンを入れてください (例 123-4567)')
      end
      it 'postal_codeが「3桁ハイフン4桁」でないと保存できないこと' do
        @order_address.postal_code = '1234567'
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('郵便番号 はハイフンを入れてください (例 123-4567)')
      end
      it 'prefecture_idを選択していないと保存できないこと' do
        @order_address.prefecture_id = 1
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('都道府県 を選択してください')
      end
      it 'cityが空だと保存できないこと' do
        @order_address.city = ''
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('市区町村 を入力してください')
      end
      it 'house_numberが空だと保存できないこと' do
        @order_address.house_number = ''
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('番地 を入力してください')
      end
      it 'telephone_numberが空だと保存できないこと' do
        @order_address.telephone_number = ''
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('電話番号 を入力してください')
      end
      it 'telephone_numberが9桁以下では保存できないこと' do
        @order_address.telephone_number = '090123456'
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('電話番号 は10桁または11桁の半角数値で入力してください')
      end
      it 'telephone_numberが12桁以上では保存できないこと' do
        @order_address.telephone_number = '090123456789'
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('電話番号 は10桁または11桁の半角数値で入力してください')
      end
      it 'telephone_numberに半角数字以外が含まれている場合は保存できないこと（ハイフンなど）' do
        @order_address.telephone_number = '090-1234-5678'
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('電話番号 は10桁または11桁の半角数値で入力してください')
      end
      it 'userが紐付いていないと保存できないこと' do
        @order_address.user_id = nil
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('User を入力してください')
      end
      it 'itemが紐付いていないと保存できないこと' do
        @order_address.item_id = nil
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('Item を入力してください')
      end
      it 'tokenが空では保存できないこと' do
        @order_address.token = nil
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('クレジットカード情報 を入力してください')
      end
    end
  end
end
