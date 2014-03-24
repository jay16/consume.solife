require 'spec_helper'

describe Record do
  before do
    @record = create(:record)
  end
  subject { @record }

  it { should belong_to(:user) }
  it { should validate_presence_of(:value) }
  it { should validate_presence_of(:ymdhms) }

end
