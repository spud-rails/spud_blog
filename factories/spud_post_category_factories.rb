FactoryGirl.define do
  sequence :category_name do |n|
    "Post Category #{n}"
  end

  factory :spud_post_category do
    name { FactoryGirl.generate(:category_name)}
  end
end
