require 'spec_helper'

describe SpudPostCategory do

  it {should have_and_belong_to_many(:posts)}


  describe :validations do
    it "should require a name" do
      p = FactoryGirl.build(:spud_post_category,:name => nil)
      p.should_not be_valid
    end

    it "should require a unique" do
      s = FactoryGirl.create(:spud_post_category, :name => "Test")
      p = FactoryGirl.build(:spud_post_category,:name => "Test")
      p.should_not be_valid
    end

    it "should be valid if validations are met" do
      p = FactoryGirl.build(:spud_post_category)
      p.should be_valid
    end

  end

  describe :set_url_name do
    it "should set the url name before validate" do
      p = FactoryGirl.build(:spud_post_category)
      p.should be_valid
      p.url_name.should == p.name.parameterize
    end
  end

  describe :posts_with_children do
    it "should collect all posts with this category and childs" do
      category = FactoryGirl.create(:spud_post_category)
      child_category = FactoryGirl.create(:spud_post_category, :parent => category)
      category.reload
      post = FactoryGirl.create(:spud_post,:categories => [category])
      post2 = FactoryGirl.create(:spud_post, :categories => [child_category])
      post3 = FactoryGirl.create(:spud_post)

      category.posts_with_children.count.should == 2
    end
  end

  describe :update_child_categories do
    it "should move children up to the categories parent on destroy" do
      category        = FactoryGirl.create(:spud_post_category)
      child_category  = FactoryGirl.create(:spud_post_category, :parent => category)
      child_child_cat = FactoryGirl.create(:spud_post_category, :parent => child_category)
      child_category.reload
      child_category.destroy
      child_child_cat.reload

      child_child_cat.parent.should == category
    end
  end

end
