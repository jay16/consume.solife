require 'spec_helper'

describe Record do
  subject { create(:record) }

  it { should belong_to(:user) }
  it { should validate_presence_of(:value) }
  it { should validate_presence_of(:ymdhms) }

  describe "record with tags" do
    before do
      @record = create(:record) 
      @tag1 = Tag.find_or_create_by(label: "hello")
      @tag2 = Tag.find_or_create_by(label: "world")
    end

    it "should build with two tags after create" do
      @record.tags.size.should eq(2)
    end

    it "should distinct tags with dumplicate tags" do
      @record.tags << @tag1
      @record.tags << @tag2
      @record.tags << @tag2
      @record.tags << @tag2
      @record.tags.size.should eq(4)
    end
  end
end
