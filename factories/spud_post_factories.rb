FactoryGirl.define do
  sequence :post_title do |n|
    "Post #{n}"
  end

  factory :spud_post do
    title { FactoryGirl.generate(:post_title)}
    content "Test Content"
    spud_user_id 1
    visible true
    published_at Time.now.utc - 1.day
  end
end
