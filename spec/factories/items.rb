FactoryBot.define do
  factory :item do
    item_name        { Faker::Commerce.product_name }
    description      { Faker::Lorem.sentence }
    category_id      { 2 } # 「---」以外を選択
    condition_id     { 2 }
    postage_id       { 2 }
    prefecture_id    { 2 }
    shipping_date_id { 2 }
    price            { 500 }
    association :user

    after(:build) do |item|
      item.image.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
    end
  end
end
