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
      @record.tags << @tag1
      @record.tags << @tag2
      @record.tags.size.should >= 2
    end

    it "should build with two tags after build" do
      RecordWithTag.create({record_id: @record.id, tag_id: @tag1.id})
      RecordWithTag.create({record_id: @record.id, tag_id: @tag2.id})
      @record.tags.size.should >= 2
    end
  end
end
