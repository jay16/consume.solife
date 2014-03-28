#encoding: utf-8
require 'spec_helper'

describe Record do
  subject { create(:record) }

  it { should belong_to(:user) }
  it { should validate_presence_of(:value) }
  it { should validate_presence_of(:ymdhms) }

  describe ".tags" do
     before :each do
       @record = create(:record)
     end

     after :each do
       @record.destroy
     end

    it "should build two tags with action :create" do
      expect(@record.tags.count).to eq(2)
      expect(@record.tags_string).to eq("one,two")
    end

    it "should distinct tags when add repeated tags" do
      @user = @record.user
      @tag = @user.tags.new({label: "three"})
      @record.tags << @tag
      @record.tags << @tag
      expect(@record.tags.count).to eq(3)
      expect(@record.tags_string).to eq("one,two,three")
    end

    it "should add new and remove old tags when :update" do
      @record.tags_list = "one,three,four"
      @record.update_attribute(:value, rand(1000)+@record.value)
      expect(@record.tags.count).to eq(3)
      expect(@record.tags_string).to eq("one,three,four")
    end

    it "should return false when :update without change" do
      @record.tags_list = "five"
      @record.update_attributes({}).should be_true
      expect(@record.tags.count).to eq(1)
      expect(@record.tags.map { |t| t.label }.join(",")).to eq("five")
    end
  end
end
