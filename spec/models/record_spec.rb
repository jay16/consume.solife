require 'spec_helper'

describe Record do
  subject { create(:record) }

  it { should belong_to(:user) }
  it { should validate_presence_of(:value) }
  it { should validate_presence_of(:ymdhms) }

  describe "record with tags" do
    # before :all do; end

    # after :all do; end

    it "should build with two tags after create" do
      @record = create(:record)
      @record.tags.count.should eq(2)
      @record.tags.map { |t| t.label }.join(",").should == "one,two"
    end

    it "should distinct tags with dumplicate tags" do
      @record = create(:record)
      @user = @record.user
      @tag = @user.tags.new({label: "three"})
      @record.tags << @tag
      @record.tags << @tag
      @record.tags.count.should eq(3)
      @record.tags.map { |t| t.label }.join(",").should == "one,two,three"
    end

    it "should add new tags and remove old tags after update" do
      @record = create(:record)
      @record.tags_list = "one,three,four"
      @record.update_attribute(:value, rand(1000)+@record.value)
      @record.tags.count.should eq(3)
      @record.tags.map { |t| t.label }.join(",").should == "one,three,four"
    end
  end
end
