FactoryBot.define do
  factory :shipping_address do
    postal_code { 'MyString' }
    prefecture_id { 1 }
    city { 'MyString' }
    house_number { 'MyString' }
    building_name { 'MyString' }
    telephone_number { 'MyString' }
    order { nil }
  end
end
