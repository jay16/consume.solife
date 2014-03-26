require 'spec_helper'

describe RecordWithTag do
  before do
    @record = create(:record)
    @tag = create(:tag)
    @record_with_tag = RecordWithTag.create({record_id: @record.id, tag_id: @tag.id})
  end

  it "should record,tag,record_with_tag valid" do
     @record.should be_valid
     @tag.should be_valid
     @record_with_tag.should be_valid
  end

  it "should build relate with record" do
    @record.tags.size.should >= 1
    @tag.records.size.should >=1
  end
end
