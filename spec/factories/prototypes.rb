# spec/factories/prototypes.rb
FactoryBot.define do
  factory :prototype do
    association :user
    title      { "サンプルタイトル" }
    catch_copy { "サンプルキャッチコピー" }
    concept    { "サンプルコンセプト" }

    after(:build) do |prototype|
      # ActiveStorage に画像を添付
      prototype.image.attach(
        io: File.open(Rails.root.join('spec/fixtures/files/test_image.png')),
        filename: 'test_image.png',
        content_type: 'image/png'
      )
    end
  end
end
